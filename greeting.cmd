@echo off

cls

echo -------------------------------------
echo ( :  ! W E L C O M E  B A C K !  : )
echo -------------------------------------

:: Display the date and time

:: Get the current time
set "CurrentTime=%TIME%"

:: Extract the hour, minute, and seconds
for /f "tokens=1-3 delims=:" %%A in ("%CurrentTime%") do (
    set "Hour=%%A"
    set "Minute=%%B"
    set "Second=%%C"
)

:: Determine whether it's AM or PM
set "AMPM=AM"
if %Hour% geq 12 set "AMPM=PM"

:: Convert to 12-hour format
if %Hour% lss 10 (
    set "FormattedTime=%Hour%:%Minute% %AMPM%"
) else if %Hour% equ 12 (
    set "FormattedTime=%Hour%:%Minute% %AMPM%"
) else (
    set /a "Hour-=12"
    set "FormattedTime=%Hour%:%Minute% %AMPM%"
)

echo ^> %FormattedTime%

:: Get the current date and time
for /f "delims=" %%A in ('wmic os get LocalDateTime ^| find "."') do set "DateTime=%%A"

:: Extract the date and time components
set "Year=%DateTime:~0,4%"
set "Month=%DateTime:~4,2%"
set "Day=%DateTime:~6,2%"

:: Convert month number to month name
set "MonthName="
if %Month% equ 01 set "MonthName=January"
if %Month% equ 02 set "MonthName=February"
if %Month% equ 03 set "MonthName=March"
if %Month% equ 04 set "MonthName=April"
if %Month% equ 05 set "MonthName=May"
if %Month% equ 06 set "MonthName=June"
if %Month% equ 07 set "MonthName=July"
if %Month% equ 08 set "MonthName=August"
if %Month% equ 09 set "MonthName=September"
if %Month% equ 10 set "MonthName=October"
if %Month% equ 11 set "MonthName=November"
if %Month% equ 12 set "MonthName=December"

setlocal enabledelayedexpansion

REM Get the current day of the month
for /f "tokens=2 delims==" %%a in ('wmic path win32_localtime get day /value ^| find "="') do (
    set "Day=%%a"
)

REM Define an array of day suffixes
set "day_suffix[1]=st"
set "day_suffix[2]=nd"
set "day_suffix[3]=rd"
set "day_suffix[0]=th"

REM Calculate the last digit of the day
set /a "day_ldig=Day %% 10"

REM Determine the appropriate day suffix
if %Day% equ 11 set "suffix=!day_suffix[0]!"
if %Day% equ 12 set "suffix=!day_suffix[0]!"
if %Day% equ 13 set "suffix=!day_suffix[0]!"
if %day_ldig% equ 1 set "suffix=!day_suffix[1]!"
if %day_ldig% equ 2 set "suffix=!day_suffix[2]!"
if %day_ldig% equ 3 set "suffix=!day_suffix[3]!"
if %day_ldig% geq 4 set "suffix=!day_suffix[0]!"

endlocal & set "suffix=%suffix%"

:: Get the day of the week
for /f "tokens=*" %%A in ('wmic path win32_localtime get DayOfWeek ^| findstr /r "[0-6]"') do set "DayOfWeek=%%A"

:: Map the day of the week number to the day of the week name
set "DayOfWeekName="
if %DayOfWeek% equ 0 set "DayOfWeekName=Sunday"
if %DayOfWeek% equ 1 set "DayOfWeekName=Monday"
if %DayOfWeek% equ 2 set "DayOfWeekName=Tuesday"
if %DayOfWeek% equ 3 set "DayOfWeekName=Wednesday"
if %DayOfWeek% equ 4 set "DayOfWeekName=Thursday"
if %DayOfWeek% equ 5 set "DayOfWeekName=Friday"
if %DayOfWeek% equ 6 set "DayOfWeekName=Saturday"

echo ^> %DayOfWeekName%, %MonthName% %Day%%suffix%, %Year%

echo -------------------------------------
echo ( :  ! W E L C O M E  B A C K !  : )
echo -------------------------------------

:: Pause to keep the Command Prompt window open
pause
