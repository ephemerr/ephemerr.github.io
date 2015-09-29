function zoomin(img) {
    img.style.display = "none";
    replacer = img.parentNode.getElementsByClassName("maxi")[0];
    replacer.style.display = "block";
}

function zoomout(img) {
    img.style.display = "none";
    replacer = img.parentNode.getElementsByClassName("mini")[0];
    replacer.style.display = "block";
}
