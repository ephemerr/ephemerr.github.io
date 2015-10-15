function zoomin(img) {
    maxi = img.parentNode.getElementsByClassName("maxi")[0];
    maxi.style.display = "block";
    overlay = document.getElementsByClassName("overlay")[0];
    overlay.style.display = "block";
    html = document.documentElement;
    html.style.background = "#9b9bbf";
}

function zoomout(img) {
    img.style.display = "none";
    overlay = document.getElementsByClassName("overlay")[0];
    overlay.style.display = "none";
    html = document.documentElement;
    html.style.background= "#bebefe";
}
