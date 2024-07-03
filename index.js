//03/07/24 HTML loop playback GAPLESS - RLB

console.log("Single track player version 2.5");

const Playlist = ["Text_1_small.mov", "WeekEnd_Special_Offer_A.png", "Text_2_small.mov", "WeekEnd_Special_Offer_B.png", "Text_3_small.mov", "WeekDay_Special_Offer_C.png"];
const Playtype = ["video", "image", "video", "image", "video", "image"];

let ElementIndex = 0; 
let tracker = [ElementIndex];

const container1 = document.querySelector(".container1");
const videoElement1 = document.querySelector(".container1 video");
const imageElement1 = document.querySelector(".container1 .img1 img");
const ImageTimeOut = 5000; // Image timeout
const gaplessTransition = 200; // Gapless transition time 

//Video Player
function Video_player(videoPath, targetElementVideo){	
	targetElementVideo.autoplay = true; 
	targetElementVideo.muted = true;
	targetElementVideo.src = videoPath;
	targetElementVideo.load();
	targetElementVideo.play();
	console.log("Video loaded: " + videoPath);

	setTimeout(function(){	
		imageElement1.src = "";
		console.log("Image Element cleared");
	}, gaplessTransition);
}

//Image Player
function Image_player(imagePath, targetElementImage){	
	targetElementImage.src = imagePath;
	console.log("Image loaded: " + imagePath);

	setTimeout(function(){	
		videoElement1.src = "";
		console.log("video Element cleared");
	}, gaplessTransition);

	setTimeout(function(){	
		tracker = fileTracker()
		LoadNextPlaylistItem(tracker[0]);
	}, ImageTimeOut); 		
}


function LoadNextPlaylistItem(ElementIndex){	
	tracker = [ElementIndex];

	if(Playtype[ElementIndex] === "video"){ 
		//console.log("Video_player Next ElementIndex: " + ElementIndex +  " Loading - " + Playlist[ElementIndex]);
		Video_player(Playlist[ElementIndex], videoElement1);
	}else if(Playtype[ElementIndex] === "image"){
		//console.log("Image_player Next ElementIndex: " + ElementIndex +  " Loading - " + Playlist[ElementIndex]);
		Image_player(Playlist[ElementIndex], imageElement1);
	}		
}


function fileTracker(){

	if(ElementIndex < Playlist.length - 1){
		ElementIndex++;
	}else{
		ElementIndex = 0;
		console.log("Loop Done!!!")
	} 
	tracker = [ElementIndex];

	return tracker;
}


window.onload = function() {

	console.log("Window loaded...");

	videoElement1.addEventListener("ended", (event) => {
		tracker = fileTracker()
		LoadNextPlaylistItem(tracker[0]);
	});

	videoElement1.addEventListener("playing", (event) => {
		console.log("Video playing...");
	})

	LoadNextPlaylistItem(tracker[0]);
};