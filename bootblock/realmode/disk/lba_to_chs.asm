[bits 16]

; Input: ax - LBA value
; Output: cl - Sector
;	  dh - Head
;	  ch - Cylinder
; Credits: http://www.osdever.net/tutorials/view/lba-to-chs
SECTORS_PER_TRACK equ 0x12
NUM_HEADS equ 0x2
LBACHS:
     PUSH dx			; Save the value in dx
     XOR dx,dx		; Zero dx
     MOV bx, SECTORS_PER_TRACK ; Move into place STP (LBA all ready in place)
     DIV bx			; Make the divide (ax/bx -> ax,dx)
     inc dx			; Add one to the remainder (sector value)
     push dx			; Save the sector value on the stack

     XOR dx,dx		; Zero dx
     MOV bx, NUM_HEADS	; Move NumHeads into place (NumTracks all ready in place)
     DIV bx			; Make the divide (ax/bx -> ax,dx)

     MOV ch,al		; Move al to ch (Cylinder)
     MOV dh,dl		; Move dl to dh (Head)
     POP ax			; Take the last value entered on the stack off. It doesn't need to go into the same register. (Sector)
     MOV cl, al     ; Move al to cl (Sector)
     POP dx			; Restore dx, just in case something important was originally in there before running this.
     RET			; Return to the main function