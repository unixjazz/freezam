#install.packages("sound")
#install.packages("signal")
library("sound")
library("signal")

###### COMPLETE CODE = PIRATE SHAZAM ######
snd <- loadSample("jay-z.wav")

shazam <- function (snd) {
		
	spec <- specgram(snd$sound,64*8000/1000,8000,64*8000/1000)
	
	find.constellation <- function(mat,m) { #n is the number of strips
		
		const <- matrix(TRUE,nrow=nrow(mat),ncol=ncol(mat))

		for(i in 1:m) {

			strip <- mat[((i-1)*16+1):(i*16),]

			maxs <- apply(strip,2,max) #max values in each column
			mmaxs <- matrix(maxs,nrow=m,ncol=ncol(strip),byrow=TRUE) #create a matrix where each column is assigned its max value
			cutoff <- quantile(maxs, p=0.96) #take the top 5% of the max values

			const[((i-1)*16+1):(i*16),] <- (strip==mmaxs) & (mmaxs > cutoff) #binary matrix with same dimensions of original matrix and only with points above the cutoff treshold

		}

		return(const)
	}
	
	map <- find.constellation(abs(spec$S),16)
	
	mfreqs <- matrix(1:length(spec$f),ncol=length(spec$t),nrow=length(spec$f))
	mtimes <- matrix(1:length(spec$t),ncol=length(spec$t),nrow=length(spec$f),byrow=TRUE)
	fileconst <<- cbind(mtimes[map],mfreqs[map])
	
	plot(fileconst)

	hashes <- NULL
	
	idist <- function(pt, candidates) {
		apply(candidates, 1, function(x,y){sqrt(sum((y-x)^2))}, y=pt)
	}
	
	for(i in 1:nrow(fileconst)) {
		candidates<-NULL
		targetzone_starttime <- fileconst[i,1]
		targetzone_endtime <- min(fileconst[i,1]+314, fileconst[nrow(fileconst),1])
		
		if(targetzone_starttime >= targetzone_endtime-10)
			break
		
		j<-i
		while(TRUE){
			j<-j+1
			if(fileconst[j,1] >= targetzone_endtime){
				break
			}
			else{
				candidates <- rbind(candidates,c(fileconst[j,1],fileconst[j,2]))
			}
		}

		candidates <- candidates[order(idist(fileconst[i,],candidates), decreasing = TRUE),]

		for(j in 1:min(c(10,nrow(candidates)))) {
				
				hashes <- rbind(hashes, c(fileconst[i,], ihash(fileconst[i,2], candidates[j,2], candidates[j,1]-fileconst[i,1])))
		}		
	}
	
	
	#plot(fileconst2, col=5,pch=19,xlab="columns",ylab="rows")
	return (hashes)
	
}


###################################################
ihash <- function(r1,r2,dtr) {
	dtr*2^16 + (r2-1)*2^8 + (r1-1) 
} #Hash function number one

dihash <- function(h) {
	r1 <- (h %% 2^8) + 1
	h <- (h-r1+1)/2^8
	r2 <- (h %% 2^8) + 1
	dtr <- (h-r2+1)/2^8
	return(c(r1,r2,dtr))
} #Hash function number two



##### APPLICATION OF THE CODE ######
music <- shazam(snd)
#spec <- specgram(snd$sound,64*8000/1000,8000,64*8000/1000)