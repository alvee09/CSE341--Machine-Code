
; multi-segment executable file template.

data segment
    ;Welcome menu strings
    welcome db "Welcome to hotel Paradise$"
    book db "1)Book your room$"
    check_out db "2)Check out from your room$"
    report db "3)See hotel reports (Administrative only)$"
    
    ;ask user info
    user_fname db "Enter first name: $"
    user_lname db "Enter last name: $"
    user_phone db "Enter phone number: $"
    
    ;after choosing book room , choose room type
    room_type db "What type of room you want sir?$"
    hill_view db "1)Hill view at 1 dollars per night$"
    sea_view db "2)Sea view at 2 dollars per night$"
    
    ;choose how many days to stay
    booked_for db "How many days you want to stay?$"
    
    ;after choosing room type , choose want food or not
    food db "Do you want breakfast,lunch and dinner for additional cost of 1 dollars?$" 
    
    ;NEW CODE ADDED
    food_yes db "1)Yes$" ;NEW
    food_no db "2)No$"    ;NEW

    ;ask for their nationality 
    nation db "What is your Nationality?$"
    forbangladeshi db "1)Bangadesh$"
    fornonbangladeshi db "2)Non-Bangladesh$"
    
    ;nationality variables
    bangladeshi dw 0
    non_bangladeshi dw 0
    
    ;checkout
    asking db "What is your room number sir?$"                                        ;room number ask korsi
    wrong_room db "Wrong room number entered. Enter again.$"                          ;room number ask korsi
    goodbye_msg db "You have successfully checked out$"
    
    ;reports menu 
    show_customer db "1)Show all the customers info$"
    revenue db "2)See total revenue generated so far$"
    bookings db "3)Total number of rooms booked so far$"
    
    all dw "Total number ofcustomers: $"
    BD dw "Total Bangladeshi customers: $"
    NBD dw "Total Non- Bangladeshi customers: $"

    
    ;price variable
    hill_view_price dw 1
    sea_view_price dw 2
    food_price dw 1
    
    ;room type variables
    number_of_seaview_rooms_booked dw 0
    number_of_hillview_rooms_booked dw 0
    number_of_searooms_booked dw 0
    number_of_hillrooms_booked dw 0    
    no_hillview db "Sorry, hill view room not available, you can try sea view rooms$"
    no_seaview db "Sorry, sea view room not available, you can try hill view rooms$"
    housefull_message db "Sorry sir no room available$"
    
    ;other variables
    invalid db "please choose from options 1-3 only$"
    input_invalid db "Invalid input, please choose between 1 and 2$" ;this is newly added
    number_of_rooms_booked db 0
    invalidinput db "Please enter a valid phone number$"
    
    yes db "Yes$"
    no db "No$"
    show db "Room no,First Name,Last Name,Phone no,Nationality,room type,Days of stay,food included$"  
    
    ;arrays
    room_available db 10 dup(1) ; 0 for no , 1 for yes
    f_names dw 100 dup('$')
    l_names dw 100 dup('$')
    phone dw 110 dup('*')
    days_booked_for dw 10 dup('*')
    room_type_record dw 10 dup('*') ; 0 for hill side , 1 for sea_view THIS ARRAY NAME HAD TO BE EDITED
    food_included dw 10 dup('*') ; 0 for no , 1 for yes
    nationality dw 10 dup('*') ; 0 means bangladeshi, 1 means non bangladeshi
    
    ;pointer_arrays for name and phone
    names_pointer dw 0,10,20,30,40,50,60,70,80,90
    phone_pointer dw 0,11,22,33,44,55,66,77,88,99
    
    ;array index variables
    room_index dw 0
    name_index dw 0
    phone_index dw 0
    days_booked_for_index dw 0
    
    ;new variables for v10
    bangladeshi_string db "Bangladeshi$"
    non_bangladeshi_string db "Non-Bangladeshi$"
    nationality_index dw 0
    room_type_index dw 0
    hill_string db "Hill view$"
    sea_string db "Sea view$"
    food_index dw 0
    revenuesum dw 0 
    showtotal db "Show total revenue generated$" 
    yes1 db "Total revenue generated: $"
    no1 db " Dollars$"
   
    
    
    
     
    
    
    
    
    
          
ends

stack segment
    dw   128  dup(0)
ends

code segment

; set segment registers:
    mov ax, data
    mov ds, ax
    mov es, ax
       
    
    ;set all registers to 0
    mov ax,0
    mov bx,0
    mov cx,0
    mov dx,0
    
    ;print array
    ;mov cx,10
    ;mov si,0
    ;start:
    ;mov dx,names_pointer[si]
    ;mov ah,2
    ;int 21h
    ;add si,2
    ;loop start
    
    ;Menu interface
    interface:
    
    call nextLine
    
    lea dx,welcome 
    mov ah,9
    int 21h
    
    call nextLine
    
    lea dx,book
    mov ah,9
    int 21h
     
    call nextLine
    
    lea dx,check_out 
    mov ah,9
    int 21h
     
    call nextLine
    
    lea dx,report 
    mov ah,9
    int 21h
     
    call nextLine
    
    ;take first menu input 1-4
    
    mov ah,1
    int 21h
    sub al,30h
    
    cmp al,1            ;input 1?
    je book_func
    cmp al,2            ;else,input 2?
    je check_out_func
    cmp al,3            ;else,input 3?
    je report_func    
  
    
    jmp invalid_input   ;when input not 1-3
    
    
    
    book_func:
    
    cmp number_of_rooms_booked,10
    jge housefull
    
    call nextLine
    
    call room_type_func    
    
    call nextLine
    
    call fname_func
    
    call nextLine
    
    call lname_func
    
    call nextLine 
    
    call number_func
    
    call nextLine
    
    call nationality_func
    
    call nextLine 
    
    call booked_for_func
    
    call nextLine
    ;NEW CODE ADDED
    call food_func
    
    call nextLine
    
    call revenue_func
    
    inc number_of_rooms_booked
    
    jmp interface
    
    fname_func proc
         lea dx,user_fname
         mov ah,9
         int 21h
         
         call nextLine
         mov bx,name_index      
         mov di,room_index
         
         
         mov di,room_index
         mov cx, 0
         mov cx,room_index 
         mov ax, 0
         mov ax, 10
         mul di
         mov di, ax
         mov bx, di
         add bx, 9
         ;mov names_pointer[cx],di
             
         fname_loop:
         
         mov ah,1
         int 21h
         
         mov ah, 0
         mov f_names[di],ax
         inc di
         
         cmp di, bx
         jg endofcode
         
         cmp al,0dh
         je  decrementneeded1
         jne fname_loop 
         
         decrementneeded1:
         dec di
         mov f_names[di],'$'
         inc di
         mov name_index,di
         
         endofcode:
         
         call nextLine
          ret
    fname_func endp  
         
         
         
    lname_func proc
         
         lea dx,user_lname
         mov ah,9
         int 21h
         
         mov di,room_index
         
         call nextLine 
         
         mov di,room_index
         mov cx,room_index
         mov ax, 0
         mov ax, 10
         mul di
         mov di, ax
         mov bx, di
         add bx, 9
         ;mov names_pointer[cx],di
         
         lname_loop:
         
         mov ah,1
         int 21h
         
         mov ah, 0
         mov l_names[di],ax
         inc di
         
         cmp di, bx
         jg endofcode2 
         
         cmp al,0dh
         je  decrementneeded
         jne lname_loop
         
         decrementneeded:
         dec di
         mov l_names[di],'$'
         inc di
         mov name_index,di
         

         
         call nextLine 
         endofcode2:
         
    
    ret
    lname_func endp 
 
    number_func proc
        phoneno:
        lea dx, user_phone
        mov ah, 9
        int 21h
         
        call nextLine
        mov ax,11
        mov di, room_index
        mul di
        mov di, ax
        
        mov bx,0
        mov bx, di
        add bx, 10
        
        ;mov phone_pointer[cx], di
        
        mov ax ,0
        mov ah,1
        phone_loop:
        
        int 21h
        ;mov bl, al
        ;mov bh, 0
        
        mov phone[di], ax
        inc di
        cmp di, bx
        jg endofcode3
        
        cmp al,0dh
        je invalidnumber
        jne phone_loop
        
        invalidnumber:
        lea dx, invalidinput
        mov ah, 9
        int 21h 
        
        call nextLine
        jmp phoneno
        
        endofcode3:
        call nextLine
        
        ret
   number_func endp
        
        
        
    ;changes made
    room_type_func proc
        
        room_choice:
        lea dx,room_type 
        mov ah,9
        int 21h
        
        call nextLine
        
        lea dx,hill_view 
        mov ah,9
        int 21h
        
        call nextLine
        
        lea dx,sea_view 
        mov ah,9
        int 21h
        
        call nextLine
        
        mov ah,1
        int 21h
        
        sub al, 30h
        cmp al, 1
        je hillviewselected
        jne checkseaview
        
        hillviewselected:
        cmp number_of_hillview_rooms_booked, 5
        jge nohillviwavailable
        jl hillviewavailable
        
        checkseaview:
        cmp al, 2
        je seaviewselected
        jne this_is_wrong
        
        seaviewselected:
        cmp number_of_seaview_rooms_booked, 5
        jge noseaviewavaible
        jl seaviewavailable
        
        nohillviwavailable:
        lea dx, no_hillview
        mov ah, 9
        int 21h
        call nextLine
        
        jmp room_choice
        
        noseaviewavaible:
        lea dx, no_seaview
        mov ah, 9
        int 21h
        call nextLine
        
        jmp room_choice
        
        ;room 0 -4 is hillview 
        hillviewavailable:
        mov si, 0
        check_for_hillview_room:    
        cmp room_available[si], 1
        je  allot_hillview_room
        jne next_hillview_room
        
        allot_hillview_room:
        mov room_index, si
        mov room_type_record[si], 0
        mov room_available[si], 0
        inc number_of_hillview_rooms_booked
        
        jmp end_of_roomtype_code:
        
        next_hillview_room: 
        inc si
        jmp check_for_hillview_room
        
        ; room 5-9 is seaview
        
        seaviewavailable:    
        mov si, 5
        
        check_for_seaview_room:
        cmp room_available[si], 1
        je  allot_seaview_room
        jne next_seaview_room
        
        allot_seaview_room:
        mov room_index, si
        mov room_type_record[si], 1
        mov room_available[si], 0 
        inc number_of_seaview_rooms_booked
        jmp  end_of_roomtype_code
        
        next_seaview_room: 
        inc si
        jmp check_for_seaview_room
        
        ;for invalid inputs
        this_is_wrong:
        call nextLine
        lea dx, input_invalid
        mov ah, 9
        int 21h
        
        call nextLine
        
        jmp room_choice
        end_of_roomtype_code:
        
        ret  
    
    room_type_func endp
    
    ; later edited 
    nationality_func proc
        ask_nationality:
        lea dx, nation 
        mov ah, 9
        int 21h
        
        call nextLine
        
        lea dx, forbangladeshi
        mov ah, 9
        int 21h
        
        call nextLine
        
        
        lea dx, fornonbangladeshi
        mov ah, 9
        int 21h
        
        call nextLine
        
        mov ah, 1
        int 21h
        
        sub al, 30h
        mov ah, 0
        cmp al,1
        je bangali
        jne checknonbangladesh  
        
        bangali:
        inc bangladeshi
        mov di, room_index
        mov nationality[di], 0
        jmp end_of_natianality_func
        
        checknonbangladesh:
        cmp al, 2
        je nonbangali
        jne this_is_invalid
        
        nonbangali:
        inc non_bangladeshi
        mov di, room_index
        mov nationality[di], 1
        jmp end_of_natianality_func 
        
        this_is_invalid:
        call nextLine
        lea dx, input_invalid
        mov ah, 9
        int 21h
        
        call nextLine
        
        jmp ask_nationality
        
        end_of_natianality_func:
        
        ret
        nationality_func endp
    
    
    
    booked_for_func proc
        lea dx, booked_for
        mov ah, 9
        int 21h 
        
        call nextLine
        
        mov ah,1 
        int 21h
        sub al, 30h
        mov di, room_index
        mov days_booked_for_index, di
        mov ah, 0 
        mov days_booked_for[di], ax
        
        ret
    booked_for_func endp
    
    ;NEW FUNCTION ADDED
    ;later again edited
    food_func proc ;1 will mean food is included
        food_check:
        lea dx, food
        mov ah, 9
        int 21h 
        
        call nextLine
        
        lea dx, food_yes
        mov ah, 9
        int 21h
        
        call nextLine
        
        lea dx,food_no
        mov ah, 9
        int 21h
        
        call nextLine
        
        mov ah ,1
        int 21h
        
        sub al, 30h
        cmp al, 1
        je foodis_included
        jne check_if_foodis_not_included
        
        foodis_included:
        mov di, room_index
        mov food_included[di], 1
        jmp end_of_food_func
        
        check_if_foodis_not_included:
        cmp al, 2
        je foodis_not_included
        jne not_right
        
        foodis_not_included:
        mov di, room_index
        mov food_included[di], 0
        jmp end_of_food_func
        
        not_right:
        call nextLine
        
        lea dx, input_invalid
        mov ah, 9
        int 21h
        call nextLine
        jmp food_check
         
        end_of_food_func:
        
        ret
        food_func endp
    
    revenue_func proc
                  mov si, room_index
                  mov ax, 0
                  mov ax, room_type_record[si]
                  cmp ax, 0
                  je hillviewroom
                  jne seaviewroom
                  
                  hillviewroom:
                  mov ax, days_booked_for[si]
                  mov bx, hill_view_price 
                  mul bx
                  jmp foodtaken
                  
                  seaviewroom:
                  mov ax, days_booked_for[si] 
                  mov bx, sea_view_price
                  mul bx
                  jmp foodtaken
                  
                  foodtaken:
                  mov cx,food_included[si]
                  cmp cx, 0
                  je endofrevcode
                  jne thereisfood
                  
                  thereisfood:
                  add ax, food_price 
                  
                  
                  endofrevcode:   
                  add revenuesum, ax
            ret
            revenue_func endp
        
        
        
    
    ;check out section starts here - Dhrubas part
    
    check_out_func:
    
    call nextLine
    lea dx,asking
    mov ah,9
    int 21h
    
    call nextLine
    
    check_avail:
    mov ah,1
    int 21h
    sub al,30h
    mov ah,0
    mov si,ax 
    mov cl,room_available[si]
    cmp cl,1
    je invalid_room
    jne removal
    
    
    invalid_room:
    call nextLine
    lea  dx,wrong_room
    mov ah,9
    int 21h
    jmp check_out_func:
    
    removal:
    call nextLine
    call fname_removal
    call lname_removal
    call number_removal
    call nation_reset
    call availability_reset
    call days_booked_reset
    call room_type_reset
    call food_reset
    call goodbye
    jmp interface
    
    
    
    
    fname_removal proc
         mov di,si
         mov ax, 0
         mov ax, 10
         mul di
         mov di, ax
         ;mov si, di
         mov bx, 10
         loop_check1:
         cmp bx,0
         jg fname_loop_remove
         jle end_of_fname_code
         
         fname_loop_remove:
         ;mov ah, 0
         mov f_names[di],'$'
         inc di
         dec bx
         jmp loop_check1
         
         end_of_fname_code:
         
         
         ret
    fname_removal endp
    
    lname_removal proc
         mov di,si
         mov ax, 0
         mov ax, 10
         mul di
         mov di, ax
         mov bx, 10
         
         
         loop_check2:
         cmp bx,0
         jg lname_loop_remove
         jle end_of_lname_code
         
         lname_loop_remove:
         mov l_names[di],'$'
         inc di
         dec bx
         jmp loop_check2
         
         end_of_lname_code:
         
         
         ret
    lname_removal endp
    
    number_removal proc
         mov di,si
         mov ax, 0
         mov ax, 11
         mul di
         mov di, ax
         mov bx, 11
         
         
         phone_loop_check:
         cmp bx,0
         jg phone_loop_remove
         jle endofphonecode
         
         phone_loop_remove:
         ;mov ah, 0
         mov phone[di],'$'
         inc di
         dec bx
         jmp phone_loop_check
         
         endofphonecode:
         
         
         ret
    number_removal endp
    
    
    nation_reset proc
         mov nationality[si],'*'
         ret
         nation_reset endp
    availability_reset proc
         mov room_available[si],1
         ret
         availability_reset endp
    
    
    days_booked_reset proc
        mov days_booked_for[si],'*'
        ret
        days_booked_reset endp
    
    room_type_reset proc
        mov room_type_record[si],'*'
        ret
        room_type_reset endp
    
    food_reset proc
        mov food_included[si],'*'
        ret
        food_reset endp
    goodbye proc
        lea dx,goodbye_msg 
        mov ah,9
        int 21h
        call nextLine
        ret
        goodbye endp
    
    
    ;report section starts here
    
    
    
    
    
    report_func:            
    call nextLine
    
    lea dx,show_customer
    mov ah,9
    int 21h
    
    call nextLine
    
    lea dx,revenue
    mov ah,9
    int 21h
    
    call nextLine
    lea dx,bookings
    mov ah,9
    int 21h
    
    call nextLine 
    
    mov ah,1
    int 21h
    sub al,30h
    
    cmp al,1
    je report01
     
    cmp al,2
    je report02
    
    cmp al,3
    je report03 
    
    report01:
           
        call nextLine
        
        ;set all index to 0
        mov ax,0
        mov bx,0
        mov cx,0
        mov dx,0
        
        mov room_index,0
        mov name_index,0
        mov phone_index,0
        mov days_booked_for_index,0
        mov nationality_index,0 
        mov room_type_index,0  
        
        lea dx,show ;print headers
        mov ah,9
        int 21h
        
        call nextLine
        
        mov cx,0;use as loop counter and to address present room
        
        show_loop:
        cmp cx,10
        je interface
        
        ;see room available or not
        mov si,cx 
        mov bx,0
        mov bl,room_available[si]
        cmp bx,0
        je  room_not_avail_line
        jne room_avail_line 
        
        room_avail_line:
        inc cx
        jmp show_loop
        
        room_not_avail_line:
        ;mov room_index,cx
        
        ;Point to current room name index
        ;mov si,room_index
        mov si,cx
        mov room_index, si
        mov bx,0
        mov bx,names_pointer[si]
        mov name_index,bx
        
        ;fix_phone index
        
        ;mov si,room_index
        mov si,cx
        mov bx,0
        mov bx,phone_pointer[si]
        mov phone_index,bx
        ;all bl changed to bx
        mov nationality_index,cx
        mov room_type_index,cx 
        mov days_booked_for_index,cx             
        mov food_index,cx        
                  
        
        ;print room no
        print_room:
        mov ah,2  
        mov dx,0
        ;mov dx,room_index
        mov dx,cx
        add dx,30h
        int 21h
        
       
        
        mov ah,2  ;print tab
        mov dx,09h
        int 21h
        
        ;print first name 
    
        ;new code begins
        ;mov ax, cx  
        ;mov bl,2
        ;mul bl
        ;mov si,ax
        ;mov dx,names_pointer[si]
        ;mov si, dx
        ;mov dx, 0       
        ;new code ends
        
        ;second new code begins
        ;mov di, cx
        ;mov ax, names_pointer[di]
        ;mov bl,2
        ;mul bl
        ;mov si,ax
        ;mov dx, 0   
        ;second new code fails
        
        ;old code runs
        ;mov di, cx
        ;mov si, names_pointer[di]
        ;mov dx, 0
        
        mov si,room_index
         mov ax, 0
         mov ax, 10
         mul si
         mov si, ax   
         mov ah,2
        print_f_name:
        
        
        mov dx,f_names[si]
        cmp dx,02424h
        je f_name_end
        cmp dx,'$'
        je f_name_end
        int 21h
        inc si
        jmp print_f_name
        
        f_name_end:
        mov ah,2  ;print tab
        mov dx,09h
        int 21h
        
        ;print last name
        mov di, cx
        mov si, names_pointer[di]
        mov dx, 0 
        
         mov si,room_index
         mov ax, 0
         mov ax, 10
         mul si
         mov si, ax   
         mov ah,2     
        print_l_name:
        
        
        mov dx,l_names[si]
        cmp dx,02424h
        je l_name_end
        cmp dx,'$'
        je l_name_end
        int 21h
        inc si
        jmp print_l_name
        
        l_name_end:
        mov ah,2  ;print tab
        mov dx,09h
        int 21h

        
        ;print phone
        mov di, cx
        mov si, phone_pointer[di]
        mov bx,0 ; 
                   
         mov si,room_index
         mov ax, 0
         mov ax, 11
         mul si
         mov si, ax   
         mov ah,2           
        print_phone:
        ;dl changed to dx 
     
        cmp bx,11
        je phone_end
        mov dx,0
        mov dx,phone[si] ; NEED TO CHANGE THIS TO SI
        cmp dx,02424h
        je phone_end
        cmp dx,'$'
        je phone_end
        
      
        
        int 21h
        inc si
        inc bx
        jmp print_phone
        
        phone_end:
        mov ah,2  ;print tab
        mov dx,09h
        int 21h
   
        
        ;print nationality
        mov si,cx
        mov dx, 0
        mov dx,nationality[si] 
        
        cmp dx,0
        je bangladeshi_print
        jne non_bangladeshi_print
        
        bangladeshi_print:
        mov ah,9
        lea dx,bangladeshi_string
        int 21h
        
        jmp end_of_nationality
        
        non_bangladeshi_print:
        mov ah,9
        lea dx,non_bangladeshi_string
        int 21h
        
        end_of_nationality:
        
        mov ah,2  ;print tab
        mov dx,09h
        int 21h
        
        
        ;print rooom type
        mov si,0
        mov si,cx
        mov dx, 0
        mov dx,room_type_record[si] 
        
        cmp dx,0
        je hill_type_print
        jne sea_type_print
        
        hill_type_print:
        mov ah,9
        lea dx,hill_string
        int 21h
        
        jmp end_of_room_type
        
        sea_type_print:
        mov ah,9
        lea dx,sea_string
        int 21h
        
        end_of_room_type:
        
        mov ah,2  ;print tab
        mov dx,09h
        int 21h
        
 
        
        ;print stay
      
        
        print_stay:
        mov si,0
        mov si,cx
        mov dx, 0
        mov dx,days_booked_for[si] 
        add dx,30h
        mov ah,2
        int 21h
        
        mov ah,2  ;print tab
        mov dx,09h
        int 21h
   
        
        
        ;print food
        print_food:
        mov si,0
        mov si,cx
        mov dx,food_included[si]
        cmp dx,0
        je  food_not_taken
        jne food_taken
        
        food_taken:
        lea dx,yes
        mov ah,9
        int 21h
                
        jmp food_end
        
        food_not_taken:
        lea dx,no
        mov ah,9
        int 21h
         
        food_end:
        mov ah,2  ;print tab
        mov dx,09h
        int 21h
        
        
        inc cx
        call nextLine
        inc room_index
        jmp show_loop    
      
    
    report02: ;aquibs part
    
    ;mov ah,9
    ;lea dx,showtotal 
    ;int 21h
    
    ;call nextline
    
    ;mov ah,9
    ;lea dx,yes1
    ;int 21h
    
    ;call nextline
    
    ;mov ah,9
    ;lea dx,no1
    ;int 21h
    
    call nextline 
    
    ;mov ah,1
    ;int 21h
    ;sub al,30h 
    
    ;cmp al,1
    ;je total
    
    ;cmp al,2
    ;je end_of_code
    ;jne invalid_input
    
    total:
    
    mov ah,9
    lea dx, yes1
    int 21h
    
    
    mov dx,revenuesum
    add dx, 30h
    mov ah,2 
    int 21h 
    
    mov ah,9
    lea dx, no1
    int 21h
    
    call nextLine
    
    jmp interface
    
    
    report03:  ;aquibs part 
    
    mov ax,0
    mov bx,bangladeshi
    mov cx,non_bangladeshi
    mov dx,0
    
    call nextline
    
    ;lea dx,bookings
    ;mov ah,9
    ;int 21h
    mov ax, 0 
    add ax, bx
    add ax,cx
    mov bx, ax
    
    lea dx, all
    mov ah, 9
    int 21h
    
    mov dx,bx
    add dx, 30h
    mov ah, 2
    int 21h
    
    call nextline
    
    lea dx,BD
    mov ah,9
    int 21h
    
    mov dx, bangladeshi
    add dx, 30h
    mov ah, 2
    int 21h
    
    call nextline
    
    lea dx,NBD
    mov ah,9
    int 21h 
    
    mov dx, non_bangladeshi
    add dx, 30h
    mov ah, 2
    int 21h
    
    ;call nextline
    
    ;mov ah,1
    ;int 21h
    ;sub al,30h
    
    ;cmp al,1
    ;je  printtotalbookings
    
    ;cmp al,2
    ;je  printBD
    
    ;cmp al,3
    ;je  printNBD
    
    ;printtotalbookings :
    
    ;mov ax,bangladeshi
    ;mov bx,non_bangladeshi
    ;add bx,ax
    ;mov dx,bx
    
    ;mov ah,2
    ;int 21h
    
    ;printBD :
    
    ;mov dx,0
    ;;mov dx,bangladeshi
    
   
    
    
    
    ;mov ah,2
    ;int 21h
    
    ;printNBD :
    
   ;mov dx,0
    
    ;mov dx,non_bangladeshi
    
    
    ;mov ah,2
    ;int 21h

    
    
    jmp interface
    
    invalid_input:
    call nextline
    
    lea dx,invalid
    mov ah,9
    int 21h
    
    jmp interface

    
    
    
    
    setDefault proc
        
        mov ax,0
        mov bx,0
        mov cx,0
        mov dx,0
    ret
    setDefault endp
    
    
    
    
    
    nextLine proc           ;function to proceed to the next line
    
        mov ah,2            
        mov dl,10
        int 21h
        mov dl,13
        int 21h 
        
    ret         
    nextLine endp
    
    housefull:
    call nextLine
    
    lea dx,housefull_message
    mov ah,9
    int 21h
    call nextLine
    jmp interface
    
    end_of_code:
    