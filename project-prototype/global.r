library(shiny)
library(ggplot2)
#library(scales)
#library(plyr)
library(reshape)
library(zoo)

df <- read.csv('dataframe.csv')
createData <- function(){
  return(df)
}

dt <- createData()

palette1 <- c('#8dd3c7','#ffffb3','#bebada','#fb8072','#80b1d3','#fdb462',
              '#b3de69','#fccde5','#d9d9d9','#bc80bd','#ccebc5','#ffed6f',
              '#1f78b4','#e31a1c','#ff7f00','#6a3d9a')

seriesOverview <- function(dt,var='Killed & Injured',start=1969,num=12){
  df <- dt
  xmin <- start
  xmax <- start + (num / 12)
  if(var=='var1'){
    ymin <- 1700 #1783
    ymax <- 4500 #4359
    overview <- ggplot(subset(df,variable=='total'),aes(x=time,y=value,color=factor(law))) 
  }
  if(var=='var2'){
    ymin <- 50
    ymax <- 210
    overview <- ggplot(subset(df,variable=='DriversKilled'),aes(x=time,y=value,color=factor(law)))
  }
  overview <- overview + geom_rect(xmin = xmin, xmax = xmax,
                                   ymin = ymin, ymax = ymax,fill = 'grey',color='grey') +
    geom_line() +
    ylab('Metric') +
    xlab('Time') +
    scale_x_continuous(breaks=c(seq(1970,1982,2),1983,1984,1985)) +
    scale_y_continuous(expand=c(0,0),limits=c(ymin,ymax)) +
    scale_color_manual(values=c('black','red'),guide='none') +
    theme(axis.ticks=element_blank(),
          panel.grid.minor=element_blank())
  return(overview)
}
#seriesOverview(meltdf,var='Killed',start=1972,num=14)


seriesDetail <- function(dt,var='Killed & Injured',start=1969,num=12){
  df <- dt
  xmin <- start
  xmax <- start + (num / 12)
  minor_breaks <- seq(floor(xmin), ceiling(xmax), by = 1/ 12)
  if(var=='Killed & Injured'){
    ymin <- 0 #1057
    ymax <- 4500 #2654
    detail <- ggplot(subset(df, variable %in% c('front','rear','drivers')),
                     aes(x=time,y=value,group=variable,fill=variable))
  }
  if(var=='Killed'){
    ymin <- 0 
    ymax <- 210
    detail <- ggplot(subset(df, variable == 'VanKilled'),
                     aes(x=time,y=value,group=variable,fill=variable)) +
      geom_area(data=subset(df, variable=='DriversKilled'),
                aes(x=time,y=value),alpha=0.7,fill='#31a354') +
      annotate('text',x=(xmin+xmax)/2,y=ymax-100,
               label='light green area is additional deaths killed not in Vans',
               size = 3)
  }
  detail <- detail +  geom_area() +
    scale_x_continuous(limits = c(xmin, xmax),expand = c(0, 0),
                       oob = rescale_none,breaks = seq(floor(xmin), ceiling(xmax), by = 1)) +
    scale_y_continuous(limits = c(ymin, ymax),expand = c(0, 0),
                       breaks = seq(ymin, ymax, length.out = 5)) +
    scale_fill_brewer(palette='Dark2') +
    ylab('Death Toll') +
    theme(legend.text = element_text(colour = "white",face = "bold"),
          legend.position=c(0,0),legend.justification=c(0,0),
          legend.title = element_blank(),legend.background = element_blank(),
          legend.direction='horizontal',
          legend.key = element_rect(fill = NA,colour = "white",size = 1)) +
    theme(axis.ticks=element_blank(),axis.title.x=element_blank())
  
  return(detail)
}

#seriesDetail(meltdf,var='Killed',start=1971.3,num=14)

bubblePlot <- function(dt,var='drivers_scale',Yr=1969,text=T,months='All'){
  df <- dt[,c('kms','PetrolPrice','year','month',var)]
  names(df)[5] <- 'var'
  miny <- min(df$kms) - 1000
  maxy <- max(df$kms)
  minx <- min(df$PetrolPrice)
  maxx <- max(df$PetrolPrice)
  if(months=='All'){
    bubble <- ggplot(subset(df,year==Yr),
                     aes(x=PetrolPrice,y=kms,color=factor(month))) +
      geom_point(aes(size=var),alpha=.5)
  }else{
    bubble <- ggplot(subset(df,year==Yr & month %in% months),
                     aes(x=PetrolPrice,y=kms,color=factor(month))) +
      geom_point(aes(size=var),alpha=.8)
  }
  if(text==T){
    bubble <- bubble + geom_text(aes(label=month),color='black',vjust=2,size=4)
  }
  bubble <- bubble +
    scale_size_area(max_size = 20, guide='none') +
    scale_color_manual(values=palette1,guide='none') +
    scale_y_continuous(limits=c(miny,maxy)) +
    scale_x_continuous(limits=c(minx,maxx)) +
    theme(axis.ticks=element_blank(),
          panel.grid.minor=element_blank()) +
    xlab('Petroleum Price (Unknown Unit)') + ylab('Total Distance Travelled (kms)')
  return(bubble)
} 

#bubblePlot(dt,var='drivers_scale',Yr=1970,text=T,months='All')
