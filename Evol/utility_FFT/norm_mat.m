
function xout = norm_mat (x,row_or_column)  
    % row_or_column = 1 for row, 2 for column
    if row_or_column == 1
        x_toprow = repmat(x(1,:),size(x,1),1);
        xout = x ./ x_toprow;
    elseif row_or_column == 2
        x_topcol = repmat(x(:,1),1,size(x,2));
        xout = x ./ x_topcol;
    end
end

