#include <hardware/custom.h>

#include "custom_input.h"
#include "graphics.h"
#include "sludger.h"

extern struct inputType input;

UWORD counterx_old = 0;
UWORD countery_old = 0;

void CsiCheckInput() {
    volatile struct Custom *custom = (struct Custom*)0xdff000;
    UWORD value = custom->joy0dat;
    UBYTE countery_new = (UBYTE) (custom->joy0dat >> 8);
    UBYTE counterx_new = (UBYTE) (custom->joy0dat & 0xffff);

    if(counterx_new)
    {
        WORD counterx_diff = counterx_new - counterx_old;

        if(counterx_diff > 127) {
            input.justMoved = TRUE;                
            counterx_diff -= 256;    
        } else if (counterx_diff < -128) {
            counterx_diff += 256;
            input.justMoved = TRUE;
        } else if (counterx_diff) {
            input.justMoved = TRUE;
        }

        input.mouseX += counterx_diff;

        if( input.mouseX > (int) winWidth) {
            input.mouseX = winWidth;            
        }
        else if(input.mouseX < 0) {
            input.mouseX = 0;
        }

        //KPrintF("CsiCheckInput: MouseX = %d\n", input.mouseX);
        counterx_old = counterx_new;
    }    

    if(countery_new)
    {
        WORD countery_diff = countery_new - countery_old;

        if(countery_diff > 127) {
            input.justMoved = TRUE;                
            countery_diff -= 256;    
        } else if (countery_diff < -128) {
            input.justMoved = TRUE;                
            countery_diff += 256;
        } else if (countery_diff) {
            input.justMoved = TRUE;
        }

        input.mouseY += countery_diff;

        if( input.mouseY > (int) winHeight) {
            input.mouseY = winHeight;            
        }
        else if(input.mouseY < 0) {
            input.mouseY = 0;
        }

        //KPrintF("CsiCheckInput: MouseX = %d\n", input.mouseX);
        countery_old = countery_new;
    } 

    input.leftRelease = FALSE;
    input.rightRelease = FALSE;

    if(input.leftClick && ((*(volatile UBYTE*)0xbfe001)&64))
    {
        input.leftClick = FALSE;
        input.leftRelease = TRUE;
    }

    if(input.rightClick && ((*(volatile UWORD*)0xdff016)&(1<<10)))
    {
        input.rightClick = FALSE;
        input.rightRelease = TRUE;
    }


    if(!((*(volatile UBYTE*)0xbfe001)&64)) {
        input.leftClick = TRUE;              
    } 
    if(!((*(volatile UWORD*)0xdff016)&(1<<10)) ) {
        input.rightClick = TRUE;
    }

}