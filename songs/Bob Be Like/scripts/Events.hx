function beatHit(curBeat:Int){
    switch(curBeat){
        case -4:
            defaultCamZoom = 0.5;
        case 8 | 24:
            defaultCamZoom += 0.1;
        case 40 | 67:
            defaultCamZoom -= 0.1;
        case 72 | 168 | 352: 
            bop = !bop;
        case 416:
            bop = false;
            defaultCamZoom -= 0.2;
    }
}