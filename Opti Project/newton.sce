//newton method

clc
//function to calculate value
function f=funcval(x)
    f = 100*(x(2)-x(1)^2)^2+(1-x(1))^2;
endfunction

//function to calculate gradient at point x
function g=gradient(x)
    g(1)=-400*x(1)*x(2)+400*x(1)^3+2*x(1)-2;
    g(2)=200*x(2)-200*x(1)^2;
endfunction

//function to calculate hessian of function at point x
function h=hessian(x)
    h(1,1)=-400*x(2)+1200*x(1)^2+2;
    h(1,2)=-400*x(1);
    h(2,1)=-400*x(1);
    h(2,1)=200;
endfunction

//main program
iter=3;

x0=[-2 1]; 
disp('Initial point:');
disp(x0);
disp('Function value at this point:');
disp(funcval(x0));
for i=1 : iter
    g=gradient(x0);
    h=hessian(x0);
    inverse=inv(h);
    p=-1*inverse*g;
    x0=x0+p';
    disp('Iteration: ');
    disp(i);
    disp('New point:')
    disp(x0)
    f=funcval(x0);
    disp('Function value at this point:')
    disp(f)
end
