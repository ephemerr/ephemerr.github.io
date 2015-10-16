function zoomin(img) {
    var maxi = document.createElement('img');
    maxi.className = 'maxi'
    maxi.src = img.getAttribute("max");
    maxi.style.display = "block";
    maxi.setAttribute("onclick", "zoomout(this)");
    img.parentNode.appendChild(maxi);
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
