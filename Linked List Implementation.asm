
DATA SEGMENT
    
    MSG DB 0AH,0DH,0AH,0DH,"ENTER CHOICE : 1.ADD 2.DELETE AT LAST 3.SEARCH: $"
    CHOICE DB ?
    MSG1 DB 0AH,0DH,0AH,0DH,"ENTER THE VALUE : $"
    MSG2 DB 0AH,0DH,0AH,0DH,"THE VALUE IS : $"
    MSG3 DB 0AH,0DH,0AH,0DH,"THE QUEUE IS EMPTY....!!$"
    MSG4 DB 0AH,0DH,0AH,0DH,"DO YOU WANT TO CONITNUE..??$"
    MSG5 DB 0AH,0DH,0AH,0DH,"NOT PRESENT!$"
    MSG6 DB 0AH,0DH,0AH,0DH,"PRESENT !$"  
    SRCH DB ?
    S DB ?
    M DB "HELLO!$"
DATA ENDS



STACK_SEG SEGMENT STACK
    
    DW 256 DUP(0)
    ST LABEL WORD
     
ENDS



CODE SEGMENT
    
    ASSUME CS:CODE,DS:DATA,SS:STACK_SEG
    
        MOV AX,DATA
        MOV DS,AX
        MOV AX,STACK_SEG
        MOV SS,AX
        MOV SP,OFFSET ST  
        MOV BP,SP 
        MOV BX,OFFSET S
        MOV SI,SP
        
MAIN:
        MOV AH,09H
        MOV DX,OFFSET MSG
        INT 21H
        
        MOV AH,01
        INT 21H
        
        CMP AL,'1'
        JE ADD1
        CMP AL,'2'
        JE DELETE 
        CMP AL,'3'
        JE SEARCH
        
SEARCH:        
        MOV AH,09
        LEA DX,MSG1
        INT 21H
        
        MOV AH,01
        INT 21H         
        MOV DI,BP
        MOV SRCH,AL
        
SCH:  
        CMP SI,DI
        JE NO
        PUSH BP
        MOV BP,SS:[DI]  
        CMP AL,DS:[BP]
        
        JE YES  
        POP BP
        SUB DI,2
        JMP SCH
               
        
NO:     MOV AH,09
        MOV DX,OFFSET MSG5
        INT 21H
        
        JMP EXIT
        
        
YES:    POP BP
        MOV AH,09
        MOV DX,OFFSET MSG6
        INT 21H
        JMP EXIT        

ADD1:        
        MOV AH,09
        MOV DX,OFFSET MSG1
        INT 21H
        
        MOV AH,01
        INT 21H
        
        PUSH DI
        PUSH BP   
        MOV DI,00
        
ADD2:
        CMP S+DI,00
        JE STORE  
        INC DI
        JMP ADD2
                                  
STORE:   
        MOV S+DI,AL     
        MOV BP,OFFSET S 
        ADD BP,DI     
        MOV DX,BP  
        POP BP
        POP DI
        MOV SS:[SI],DX      
        SUB SI,2 
        SUB SP,2       ;TO AVOID OVERWRITE STACK SEGMENT
        JMP EXIT
                
DELETE: 
        CMP SI,BP
        JE EMPTY 
        
        MOV AH,09
        MOV DX,OFFSET MSG2
        INT 21H  
                        
        MOV DI,SS:[BP]
        MOV AL,[DI]
        MOV [DI],00
        
        MOV AH,02
        MOV DL,AL
        INT 21H   
        
        PUSH BP
        
        SUB BP,SI 
        MOV AX,BP
        POP BP
        PUSH BP
        MOV CH,2
        DIV CH         ;COUNTER
        
ADJUST:     
        SUB BP,2 
        MOV CX,[BP]
        ADD BP,2
        MOV [BP],CX
        SUB BP,2
        DEC AX
        JNZ ADJUST 
        POP BP
        ADD SI,2        
        JMP EXIT
        
EMPTY:
        MOV AH,09
        MOV DX,OFFSET MSG3
        INT 21H 
        
EXIT:   
        MOV AH,09
        MOV DX,OFFSET MSG4
        INT 21H
        
        MOV AH,01
        INT 21H
        
        CMP AL,'Y'
        JE MAIN
        CMP AL,'y'
        JE MAIN
        
                
        MOV AX,4C00H
        INT 21H
        
ENDS