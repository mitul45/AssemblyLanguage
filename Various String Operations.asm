; MULTI-SEGMENT EXECUTABLE FILE TEMPLATE.

DATA SEGMENT
    
    LIST DB "1.FIND LENGTH 2.CONVERT TO UPPER 3.REVERSE THE STRING 4.PALINDROME CHECK 5.CHAR SEARCH 6.NO OF OCCURENCE 7.SUBSTRING SEARCH 8.ADDITION OF 2-ARRAY 9.EXIT$"
    CHO  DB 0DH,0AH,0DH,0AH,"ENTER CHOICE : $"
    PY   DB 0DH,0AH,0DH,0AH,"PALINDROME...$"
    PN   DB 0DH,0AH,0DH,0AH,"NOT PALINDROME...$" 
    MSG  DB 0DH,0AH,0DH,0AH,"ENTER THE STRING : $"
    UP   DB 0DH,0AH,0DH,0AH,"UPPER CASE : $"
    REV  DB 0DH,0AH,0DH,0AH,"REVERSE STRING : $"
    LN   DB 0DH,0AH,0DH,0AH,"LENGTH : $"
    CH1  DB 0DH,0AH,0DH,0AH,"ENTER A CHARCTER TO SEARCH : $"
    MSG2 DB 0DH,0AH,0DH,0AH,"CHARACHTER FOUND AT : $"
    MSG1 DB 0DH,0AH,0DH,0AH,"CHAR NOT FOUND...$"
    MSG3 DB 0DH,0AH,0DH,0AH,"NO OF OCCURANCE : $"
    MSG4 DB 0DH,0AH,0DH,0AH,"ENTER STRING TO SEARCH : $"
    MSG5 DB 0DH,0AH,0DH,0AH,"STRING FOUND...$"
    MSG6 DB 0DH,0AH,0DH,0AH,"STRING NOT FOUND...$"
    
    
    C      DB ?
    CNT    DB 00
    CH2    DB ? 
    STR    DB 10 DUP(0)
    STRSER DB 10 DUP(0)
    REV1   DB 10 DUP(0)
    LEN    DW ?
    CNTS   DB 00H
    
ENDS

STACK SEGMENT
    
    DW   128  DUP(0) 
    
ENDS

CODE SEGMENT        
    
START:
; SET SEGMENT REGISTERS:
    MOV AX, DATA
    MOV DS, AX
    MOV ES, AX
    
    MOV AH,09
    LEA DX,LIST
    INT 21H
    
    MOV AH,09
    LEA DX,CHO
    INT 21H 
    
    MOV AH,01
    INT 21H
    MOV C,AL
    
    CMP C,'9'
    JZ EXIT
    
    
  ;  CMP C,'8'
  ;  JZ ARR
 
    MOV AH,09
    LEA DX,MSG
    INT 21H  
    
    MOV STR,10H
    
    MOV AH,0AH
    LEA DX,STR
    INT 21H
            
    LEA BX,STR
    INC BX
    MOV CL,[BX]
    MOV CH,00
    MOV LEN,CX
    
        
 ;   MOV CL,LEN
    LEA BX,STR
    INC BX
    MOV CL,[BX]
    MOV CH,00
    ADD BX,CX
    INC BX
    MOV [BX],'$'
    
    CMP C,'1'
    JZ LENGTH
    
    CMP C,'2'
    JZ UPP
    
    CMP C,'3'
    JZ REVERSE
    
    CMP C,'4'
    JZ REVERSE 
    
    CMP C,'5'
    JZ SER
    
    CMP C,'6'
    JZ OCC
    
    CMP C,'7'
    JZ S

	
    
S:  JMP SUBSER
    
PAL:
    
    LEA SI,STR+2
    LEA DI,REV1
    CMPSB 
    JZ PALY
    MOV AH,09
    LEA DX,PN
    INT 21H
    JMP EXIT
    
PALY:
    
    MOV AH,09
    LEA DX,PY
    INT 21H
    JMP EXIT           
    
    
UPP:

    LEA BX,STR
    ADD BX,2
    
L1: 

    SUB [BX],32
    INC BX
    DEC CX
    JNZ L1
    
    JMP UPPP


OCC: 
   
SER:
     CALL SEARCH
     JMP EXIT
               

REVERSE:
    
    MOV BX,OFFSET STR
    MOV BP,OFFSET REV1
    ADD BX,LEN
    INC BX
    MOV CX,LEN
L:  MOV AL,[BX]
    MOV DS:[BP],AL
    DEC BX
    INC BP
    DEC CX
    JNZ L 
    
    
    LEA BX,REV1
    MOV CH,00
    MOV CX,LEN
    ADD BX,CX
    MOV [BX],'$'
    CMP C,'4'
    JZ PAL
    JMP REVP           
    
LENGTH: 

    MOV AH,09
    LEA DX,LN
    INT 21H
    
    ADD LEN,30H
    
    MOV AH,02
    MOV DX,LEN
    INT 21H
    JMP EXIT
          
UPPP: 

    MOV AH,09
    LEA DX,UP
    INT 21H
    
    MOV AH,09
    LEA DX,STR+2
    INT 21H
    JMP EXIT
    
REVP:

    MOV AH,09
    LEA DX,REV
    INT 21H
    
    MOV AH,09
    LEA DX,REV1
    INT 21H
    JMP EXIT
              
SUBSER:

     MOV AH,09
     LEA DX,MSG4
     INT 21H  
     
     MOV STRSER,10H 
     
     MOV AH,0AH
     LEA DX,STRSER
     INT 21H 
     
     LEA BX,STRSER
     INC BX
     MOV CL,[BX]
     MOV CH,00
        
        
     LEA BX,STRSER
     INC BX
     MOV CL,[BX]
     MOV CH,00
     ADD BX,CX
     INC BX
     MOV [BX],'$'
     
     LEA SI,STR
     ADD SI,2
     LEA DI,STRSER
     INC DI
     MOV CH,[DI]
     INC DI
LI:
     MOV BH,[DI] 
        
     CMP [SI],BH
     JZ X
     INC SI
     DEC CH
     JNZ LI
     JMP NOTFOUND  
X:   

     DEC CH
     
L5:  
           
     ;INC CNTS
     INC SI
     INC DI
     DEC CH
     JZ FOUND
     MOV BH,[DI]
     CMP [SI],BH
     JNZ NOTFOUND
     
     JMP L5
        
     
 
      
FOUND:
     
     MOV AH,09
     LEA DX,MSG5
     INT 21H
     JMP EXIT
     
NOTFOUND:
    
     MOV AH,09H
     LEA DX,MSG6
     INT 21H
     JMP EXIT     
             

SEARCH PROC NEAR  
    
    MOV AH,09
    LEA DX,CH1
    INT 21H
    
    MOV AH,01
    INT 21H
    MOV CH2,AL
              
    LEA BX,STR+2
    MOV CH,00
    MOV CX,LEN
LL: 
    MOV DH,[BX]
    CMP DH,CH2
    JZ FIND
    INC BX
    DEC CL
    JNZ LL
    CMP C,'5'
    JZ NOTF
    JMP LP
    
FIND:
        CMP C,'6'
        JZ LA
        MOV AH,09
        LEA DX,MSG2
        INT 21H
    
       ;MOV CX,LEN
        MOV AX,LEN
        SUB AL,CL
        MOV CL,AL
        INC CL 
        ADD CL,30H
        MOV AH,02
        MOV DL,CL
        INT 21H
        JMP RT
    
NOTF:
     MOV AH,09
     LEA DX,MSG1
     INT 21H
     
     CMP C,'6'
     JZ LP
     
     JMP EXIT  
     
LA:  
     INC CNT
     INC BX 
     DEC CL
     JNZ LL
     
LP: 
     MOV AH,09H
     LEA DX,MSG3
     INT 21H

     MOV AH,02
     ADD CNT,30H
     MOV DL,CNT
     INT 21H  
     

RT:  
     RET
SEARCH ENDP  

EXIT: 
    
    MOV AX, 4C00H ; EXIT TO OPERATING SYSTEM.
    INT 21H    
ENDS

END START ; SET ENTRY POINT AND STOP THE ASSEMBLER.