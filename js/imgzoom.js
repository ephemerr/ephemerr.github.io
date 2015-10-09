function zoomin(img) {
    maxi = img.parentNode.getElementsByClassName("maxi")[0];
    maxi.style.display = "block";
    overlay = document.getElementsByClassName("overlay")[0];
    overlay.style.display = "block";
}

function zoomout(img) {
    img.style.display = "none";
    overlay = document.getElementsByClassName("overlay")[0];
    overlay.style.display = "none";
}
