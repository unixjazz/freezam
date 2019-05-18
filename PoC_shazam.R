# PoC Shazam

# load the dependencies: sound for spectrogram analysis
library("sound")

# plus, signal processing lib
library("signal")

# load file
jz <- loadSample("jay-z.wav")

# describe file
class(jz)

# what does it contain?
names(jz)

# what is the type of 'sound' content?
class(jz$sound)

# constants
jz$rate
jz$bits

# slice a part of the sample (4 secs: 8K samples / sec)
jz[1:32000]

# plot 55 seconds into the song (8K samples / sec)
plot(jz[(53*8000+1):(57*8000)])

# compute spectrogram, 15 seconds, for the sample
# sampling rate of the signal + constants for fourier transform (64ms)
jzspec <- specgram(jz$sound[(50*8000+1):(65*8000)],64*8000/1000,8000,64*8000/1000)

# check obj type
class(jzspec)

# check what the object contains
names(jzspec)
class(jzspec$S)
dim(jzspec$S)

# plot jzspec: black (low intensity) and white (high intensity)
plot(jzspec)

# make it look like the paper on Shazam!
grays <- gray((100:0)/100) 

# image() takes vectors that correspond to the column and row values
# (here time and freq) and a matrix
image(jzspec$t,jzspec$f,t(abs(jzspec$S)),col=grays,xlab="time",ylab="frequency")
title("jayz, empire state of mind - sample"

# slice of full spectrogram
bigspec <- specgram(jz$sound,64*8000/1000,8000,64*8000/1000)
plot(bigspec$t,abs(bigspec$S[177,]),type="l",xlab="times",ylab="intensity at 2750 Hz")
title("a slice from the full spectrogram for jayz")

# Shazam proper:
# Divide the object into 256 freq (rows in the specgram object) into 16 bins
# Create strips across time
# Compute maximum of each column
# Tag constellation points of the top 5%

freqs <- jzspec$f
times <- jzspec$t

jzmat <- abs(jzspec$S)

plot(freqs,jzmat[,400],type="l",xlab="frequency",ylab="intensity")
lines(freqs,jzmat[,100],col=5)
title("slices before and after alicia keys (cyan=before, black=after)")

# rows that go from 209 to 224 (or 3250 Hz to 3484.375 Hz)
i <- 14
((i-1)*16+1):(i*16)
strip <- jzmat[((i-1)*16+1):(i*16),]

# max values each column
maxs <- apply(strip,2,max)

# create a matrix where each column is an assigned max value
mmaxs <- matrix(maxs,nrow=16,ncol=ncol(strip),byrow=T)

# take 5% top values
cutoff <- quantile(maxs,p=0.95)

# create a binary matrix
const <- (strip==mmaxs) & (mmaxs>cutoff)

# plot results
image(times, freqs[((i-1)*16+1):(i*16)],t(strip),col=gray((100:0)/100))
image(times, freqs[((i-1)*16+1):(i*16)],t(const),col=gray(c(1,0)))

# repeat the operation for 16 strips, creating a new matrix
find_constellation <- function(mat){
    const <- matrix(TRUE,nrow=nrow(mat),ncol=ncol(mat))
    for(i in 1:16){
        strip <- mat[((i-1)*16+1):(i*16),]
        maxs <- apply(strip,2,max)
        mmaxs <- matrix(maxs,nrow=16,ncol=ncol(strip),byrow=T)
        cutoff <- quantile(maxs,p=0.95) 
        const[((i-1)*16+1):(i*16),] <- (strip==mmaxs)&(mmaxs>cutoff)
    }
    return(const)
}

# apply the function to jayz sound
jzmap <- find_constellation(jzmat)

# plot!
image(times,freqs,t(jzmap),col=gray(c(1,0)))

# Targets: identify the 10 nearest points in the constellation
# which are ahead of time (euclidian distance: row and column indices)

# first, modify the binaryematrix to a matrix with coordinates of each point
mfreqs = matrix(1:length(freqs),ncol=length(times),nrow=length(freqs))
mtimes = matrix(1:length(times),ncol=length(times),nrow=length(freqs),byrow=T)

jzconst <- cbind(mtimes[jzmap],mfreqs[jzmap])

# plot!
plot(jzconst,col=5,pch=19,xlab="columns",ylab="rows")

# pick a point in the constellation, randomly... let's say the 186th
i <- 186

# generate the candidates ahead of the point we chose
fileconst <<- cbind(mtimes[map],mfreqs[map])

# use another var to plot the distance between the point we chose
# and the candidate points

idist <- function(pt,candidates){
	    apply(candidates,1,function(x,y){ sqrt(sum((y-x)^2)) },y=pt)
}

candidates <- jzconst[jzconst[,1]>jzconst[i,1],]
candidates <- candidates[order(idist(jzconst[i,],candidates)),]

for(j in 1:10) lines(rbind(jzconst[i,],candidates[j,]))


# Hashing: in the paper, they describe creating a struct of 64bits
# the first 32 bits of the sample top freq. plus its window of candidates
# plus another 32 bits for track ID and distance from the beginning of track
# In the example below, the approach is to compute the hash of the triples

# declare hash functions
ihash <- function(r1,r2,dtr){
    dtr*2^16 + (r2-1)*2^8 + (r1-1)
}

dihash <- function(h){
    r1 <- (h %% 2^8) + 1
    h <- (h-r1+1)/2^8
    r2 <- (h %% 2^8) + 1
    dtr <- (h-r2+1)/2^8
    return(c(r1,r2,dtr))
}

# Shazam example for a mono sample file, 8000 samples/sec, 16 bits / sample
shazam <- function(snd){

    spec <- specgram(snd$sound, 64*8000/1000,8000,64*8000/1000)
    map <- find_constellation(abs(spec$S))
    
    mfreqs = matrix(1:length(spec$f),ncol=length(spec$t),nrow=length(spec$f))
    mtimes = matrix(1:length(spec$t),ncol=length(spec$t),nrow=length(spec$f),byrow=T)
    
    const <- cbind(mtimes[map],mfreqs[map])
    hashes <- NULL
    
    for(i in 1:nrow(const)){			         
    # we are going to process each song in overlapping 15 second chunks
    # and stop building constellation/target segments at 10 seconds
        if(const[i,1] < 314){
            candidates <- const[const[,1]>const[i,1],]
            candidates <- candidates[order(idist(const[i,],candidates)),]
			       
	    for(j in 1:min(c(10,nrow(candidates)))){
	        hashes = rbind(hashes,c(const[i,],	
		    ihash(const[i,2],candidates[j,2],candidates[j,1]-const[i,1])))
	    }
	}
    }   
    return(hashes)
}

# Shazam!
jzshaz <- shazam(jz[(50*8000+1):(65*8000)])

# try with an unknown sample
unknown <- loadSample("mysample.wav")
sunknown <- unknown[(30*8000+1):(45*8000)]
ushaz <- shazam(sunknown)

# matches?
sum(ushaz[,3] %in% jzshaz[,3])

# plot!
plot(ushaz[,1:2],pch=19,col=5,cex=0.5,xlab="time",ylab="frequency")
points(ushaz[,1:2][ushaz[,3] %in% jzshaz[,3],])

sunknown <- unknown[(35*8000+1):(50*8000)]
ushaz <- shazam(sunknown)
sum(ushaz[,3] %in% jzshaz[,3])

# plot!
plot(ushaz[,1:2],pch=19,col=5,cex=0.5,xlab="time",ylab="frequency")
points(ushaz[,1:2][ushaz[,3] %in% jzshaz[,3],])

