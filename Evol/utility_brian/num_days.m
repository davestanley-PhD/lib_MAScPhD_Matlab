function days = num_days(month)

switch month
    case 2
        days = 28;
    case 4
         days = 30;
    case 6
        days = 30;
    case 9
        days = 30;
    case 11
        days = 30;
    otherwise
        days = 31;
end