;;;;; Fizzbuzz in llvm IR ;;;;;

;;; Define all our constant strings
@.fizzraw = private unnamed_addr constant [5 x i8] c"fizz\00"
@.buzzraw = private unnamed_addr constant [5 x i8] c"buzz\00"
@.numformat = private unnamed_addr constant [4 x i8] c"%d\0A\00"
@.strformat = private unnamed_addr constant [4 x i8] c"%s\0A\00"
@.str2format = private unnamed_addr constant [6 x i8] c"%s%s\0A\00"

;;; Define the external printf function
declare i32 @printf(i8* noalias nocapture, ...)

;;; Take a number and output fizz, buzz, fizzbuzz, or the actual number
define void @fizzbuzz(i32 %number) {
    ;;; Get the pointers to all of our strings
    %fizz = getelementptr [5 x i8],[5 x i8]* @.fizzraw, i32 0, i32 0
    %buzz = getelementptr [5 x i8],[5 x i8]* @.buzzraw, i32 0, i32 0
    %numformat = getelementptr [4 x i8],[4 x i8]* @.numformat, i32 0, i32 0 
    %strformat = getelementptr [4 x i8],[4 x i8]* @.strformat, i32 0, i32 0 
    %str2format = getelementptr [6 x i8],[6 x i8]* @.str2format, i32 0, i32 0 

    ;;; Check for 'fizzbuzz' (divisible by 15)
    %by15 = urem i32 %number, 15
    %condby15 = icmp eq i32 %by15, 0
    br i1 %condby15, label %PrintFizzBuzz, label %CheckFizz

    PrintFizzBuzz:
    call i32 (i8*, ...) @printf(i8* %str2format, i8* %fizz, i8* %buzz)
    ret void

    ;;; Check for 'fizz' (divisible by 3)
    CheckFizz:
    %by3 = urem i32 %number, 3
    %condby3 = icmp eq i32 %by3, 0
    br i1 %condby3, label %PrintFizz, label %CheckBuzz
    
    PrintFizz:
    call i32 (i8*, ...) @printf(i8* %strformat, i8* %fizz)
    ret void

    ;;; Check for 'buzz' (divisible by 5)
    CheckBuzz:
    %by5 = urem i32 %number, 5
    %condby5 = icmp eq i32 %by5, 0
    br i1 %condby5, label %PrintBuzz, label %PrintNum
    
    PrintBuzz:
    call i32 (i8*, ...) @printf(i8* %strformat, i8* %buzz)
    ret void

    ;;; Print the number
    PrintNum:    
    call i32 (i8*, ...) @printf(i8* %numformat, i32 %number) 
    ret void
}

;;; Recursively loop until %index == 31
define void @loop(i32 %index) {
    Test:
    %cond = icmp eq i32 %index, 31
    br i1 %cond, label %Done, label %Loop

    Loop:
    call void @fizzbuzz(i32 %index)
    %subindex = add i32 %index, 1
    call void @loop(i32 %subindex)
    ret void

    Done:
    ret void
}

;;; Entry point - run the main loop and return 0 (success)
define i32 @main() {    
    call void @loop(i32 1)
    ret i32 0
}