# licensed under BSD, read: LICENSE 
install.packages("sound")
install.packages("signal")
library("sound")
library("signal")

##### STEP 1 - DOWNLOAD THE FILE #####
download.file("http://...")

file <- loadSample("file.wav")


##### STEP 2 - CREATE THE MATRIX/SPECTROGRAM #####
filespect <- specgram(file$sound[(50*8000+1):(65*8000)],64*8000/1000,8000,64*8000/1000)

#plot(filespect)
#grays <- gray ((100:0)/100)
#image(filespect$t,filespect$f,t(abs(filespect$s)), col=grays,xlab="Time",ylab="Frequency")
#title("Music")


##### STEP 3 - PRODUCE CONSTELLATION ######
freqs <- filespect$f #frequency
times <- filespect$t #time

filematrix <- abs(filespect$S) #intensity

#plot(freqs,filematrix[,400],type="l",xlab="Frequency",ylab="Intensity")
#lines(freqs,filematrix[,100],col=5)
#title("Something About the Data")

find.constellation <- function(filematrix,n) { #n is the number of strips
	
	const <- matrix(TRUE,nrow=nrow(filematrix),ncol=ncol(filematrix))
	
	for(i in 1:n) {
		
		strip <- filematrix[((i-1)*16+1):i*16,] #take lines 2009-224
		
		maxs <- apply(strip,2,max) #max values in each column
		mmaxs matrix(maxs,nrow=n,ncol=ncol(strip),byrow=TRUE) #create a matrix where each column is assigned its max value
		cutoff <- quantile(maxs, p=0.95) #take the top 5% of the max values
		
		const[((i-1)*16+1):i*16,] <- (strip==mmaxs) & (mmaxs > cutoff) #binary matrix with same dimensions of original matrix and only with points above the cutoff treshold
		
	}
	
	return(const)
}

filemap <- find.constellation(filematrix,16) #example for applying the function

#image(times, freqs, t(strip),col=gray(c(1,0)))
#image(times, freqs, t(const),col=gray(c(1,0)))


##### STEP 4 - TARGETING POINTS ######
mfreqs <- matrix(1:length(freqs),ncol=length(times),nrow=length(freqs))
mtimes <- matrix(1:length(times),ncol=length(times),nrow=length(freqs),byrow=TRUE)

fileconst <- cbind(mtimes[filemap],mfreqs[filemap])

#plot(fileconst,col=5,pch=19,xlab="columns",ylab="rows")

i <- 186 #pick a random point in the constellation

idist <- function(pt,candidates) {
	apply(candidates,1,function(x,y) { sqrt(sum((y-x)^2)) }, y=pt)
} #function which compares the distance between the i point and all the candidate points

candidates <- fileconst[fileconst[,1] > fileconst[i,1],]
candidates <- candidates[order(idist(fileconst[i,],candidates)),]

for (j in 1:10) lines(rbind(fileconst[i,], candidates[j,])) #identify 10 targest ahead of it in time



###### STEP 5 - HASHING ######
ihash <- function(r1,r2,dtr) {
	dtr*2^16 + (r2-1)*2^8 + (r1-1) 
} #Hash function number one

dihash <- function(h) {
	r1 <- h %% 2^8) + 1
	h <- (h-r1+1)/2^8
	r2 <- (h %% 2^8) + 1
	dtr <- (h-r2+1)/2^8
	return(c(r1,r2,dtr))
} #Hash function number two

ihash(15,224,131)

dihash(ihash(15,224,131))











###### COMPLETE CODE = PIRATE SHAZAM ######
snd <- loadSample("file.wav")

shazam <- function (snd,n) {
		
	spec <- specgram(snd$sound,64*8000/1000,8000,64*8000/1000)
	
	find.constellation <- function(mat,m) { #n is the number of strips
		
		const <- matrix(TRUE,nrow=nrow(mat),ncol=ncol(mat))

		for(i in 1:m) {

			strip <- mat[((i-1)*16+1):(i*16),]

			maxs <- apply(strip,2,max) #max values in each column
			mmaxs <- matrix(maxs,nrow=m,ncol=ncol(strip),byrow=TRUE) #create a matrix where each column is assigned its max value
			cutoff <- quantile(maxs, p=0.95) #take the top 5% of the max values

			const[((i-1)*16+1):(i*16),] <- (strip==mmaxs) & (mmaxs > cutoff) #binary matrix with same dimensions of original matrix and only with points above the cutoff treshold

		}

		return(const)
	}
	
	map <- find.constellation(abs(spec$S),n)
	
	mfreqs <- matrix(1:length(spec$f),ncol=length(spec$t),nrow=length(spec$f))
	mtimes <- matrix(1:length(spec$t),ncol=length(spec$t),nrow=length(spec$f),byrow=TRUE)
	
	fileconst <- cbind(mtimes[map],mfreqs[map])
	
	hashes <- NULL
	
	idist <- function(pt,candidates) {
		apply(candidates,1,function(x,y) { sqrt(sum((y-x)^2)) }, y=pt)
	}
	
	for (i in 1:nrow(fileconst)) {
		
		if (fileconst[i,1] < 314) {
			
			candidates <- fileconst[fileconst[,1] > fileconst[i,1],]
			candidates <- candidates[order(idist(fileconst[i,],candidates)),]
			
			for (j in 1:min(c(10,nrow(candidates)))) {
				
				hashes <- rbind(hashes,c(fileconst[i,],ihash(fileconst[i,2],candidates[j,2],candidates[j,1]-const[i,1])))
			}
		}
	}

	return(hashes)

}










##### APPLICATION OF THE CODE ######
music <- shazam(file[(10*8000+1):(25*8000)])

unknown <- loadSample("longsample.wav") #Sample of the music
sunknown <- unknown[(30*8000+1):(45*8000)]
ushaz <- shazam(sunknown)

sum(ushaz[,3] %in% music[,3])

plot(ushaz[,1:2],pch=19,col=5,cex=0.5,xlab="Time",ylab="Frequency")
points(ushaz[,1:2][ushaz[,3] %in% music[,3], ])

sunknown <- unknown[(5*8000+1):(20*8000)]

ushaz <- shazam(sunknown)

mm <- match(music[,3],ushaz[,3],xlab="time",ylab="sample-time",xlim=c(500,800))

plot(music[,1][!is.na(mm)],ushaz[,1][mm[!is.na(mm)]],xlab="time",ylab="sample-time", cex=0.5)

hist(music[,1][!is.na(mm)]-ushaz[,1][mm[!is.na(mm)]],breaks=100,xlab="time differences",main="seconds 5-20 of unknown",cex=0.5)
