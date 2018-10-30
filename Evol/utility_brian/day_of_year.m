function x = day_of_year(date)


month = str2double(date(1:2));
day = str2double(date(4:5));

x = 0;
for i = 1:(month-1)
    x=x+num_days(i);
end
x=x+day;

end