function Efinder
tic

%Efinder: Finds the numerical values for eigen energies that satisfy the 
%Schroedinger equation for the potential inputted. 
%Note: hbar has been scaled to 1.

%To use: =>enter mass (m=___)
%        =>enter energy range (energyrangefrom=___ ,  energyrangeto=___ )
%        =>enter the increments for the range (steps=___) 
%        =>enter the potential (at the bottem of this file in the 
%          format described there)
%        =>run
%_________________________________________________________________________

%The data will be saved to a file called Energy.txt in your workspace. The 
%data should be straightforward, but it will say nothing about which energy
%level is which (i.e. ground state,...), but it should be clear that lower
%eigen energy values correspond to the lower energy states.

%Furthermore, sometimes the energy levels are too close together for the 
%program to 'see' them, and therefore it does not collect data for those 
%particular energy levels and leaves a gap in the data. This is due to
%the energy step size, 'steps1', being larger than energy difference 
%between the energy levels. As long as you are careful about the range of 
%energies given to the program to search through, it should not be a 
%problem, though if you believe it has occurred, it can be corrected as
%described below in the commented section next to 'steps'.

%Other explanations can be found in the body of this file.



%I make no claim that there is not a better way to find the eigen energies
%that satisfy the Schroedinger equation, but using this technique of taking 
%advantage of the wave solution behavior, which this program does, the energy 
%levels for 'nearly' any potential can be ascertained numerically (I say 
%'nearly' because I have not tried them all!). 

%I hope the explanation provided is adequate, but if there are any questions
%or suggestions feel free to contact me at <isaac.obryant@und.nodak.edu> or
%leave an evaluation on the MatLab website.

%Efinder was created by Isaac O'Bryant with help from Ramesh Dhungana. 
%Physics, University of North Dakota,(c) 7/29/2005



%Here begins the program Efinder___________________________________________

format long
global e
global pot
global m
global precision




m =              ;  %enter the 'mass' used in the Schroedinger equation

precision=6      ;  %will give data correct up to at least the sixth decimal 
                    %place in this case. Change it accordingly.
                  

energyrangefrom= ;  %enter the lower end of the energy range being considered here 
energyrangeto=   ;  %enter the upper end of the energy range here
                    %(you must supply a finite range of energy values for
                    %the program to search through and that should also be
                    %appropriate for your specific situation) 

steps=           ;  %enter how many increments the above range should be 
                    %separated into (e.g. steps=300)
                    
                    %(Note: if the separation between energy levels is less
                    %than |energyrangefrom-energyrangeto|/(steps) this
                    %program will not find these energy levels; correct by
                    %breaking up original energy range into several smaller
                    %energy ranges and rerunnig this function again for each 
                    %smaller set of ranges, or by increasing the step size)
                    
                    
                    
%(optional)________________________________________________________________                  
%this will find the bottem of potential wells and use this value as part of
%the range this function will search through to find eigen energies. If you
%are dealing with such a situation in which this might be useful, uncomment
%the following remarks and comment or delete 'energyrangefrom' and 
%'energyrangeto' above and then add your potential in for pot1, making sure
%to use tt in place of t as you will need to do at the bottem of this file.

%tt=-6:.01:6;
%pot1=(-.2)*((sech(tt)).^2);    %(E.g 'pot1=(-.2)*((sech(tt)).^2)');
%potbottem=min(pot1);           %of course here the minimum is -.2, but this
                                %way is more fun and it will work for other
                                %functions as well, though the range of tt
                                %may need to be adjusted accordingly


%energyrangeto= 0;
%energyrangefrom= potbottem;




%here are the initial conditons____________________________________________

tspan = [-40,40];    %tspan is used in ode45 and may need to be changed 
                     %depending on your potential  

options= odeset('RelTol', 1e-10,'AbsTol',[1e-10 1e-10]);
y0 = [0;1];
ee=[0;1];
n=1;
data=[0 0];



%Here is the while loop____________________________________________________


while (abs(ee(end-1)-ee(end))>(1*10^(-1-precision))) | ((ee(end-1)-ee(end))==0)
    E1=[energyrangefrom;data(:,1)]; %the first range it looks at is from
    E2=[energyrangeto;data(:,2)];   %energyrangefrom to energyrangeto, then
    previous=[];                    %it uses the values from the 'for' loop
    t=[];
    y=[];

    if n>1
        steps=20;   %after it finds some energy levels, it switches to this 
    end             %stepsize and defines the energy levels more accurately 
                    %each time it goes through the while loop      
                    %(the first iteration it looks through the whole  
                    %range and finds all the energy levels using the
                    %step size you inputted for steps)
    

    for e = linspace(E1(n),E2(n),steps)	
        [t,y] = ode45(@schrod,tspan,y0,options);
        y1=y(:,1);
        ee=[ee;e];
        result=y1(end);

        if isempty(previous)
            previous=[result];
        end

        previous=[previous;result];

        if (previous(end)>0) & (previous(end-1)<0)
            data=[data;ee(end-1),ee(end)];
        elseif (previous(end)<0) & (previous(end-1)>0)	
            data=[data;ee(end-1),ee(end)];
        end	
    end

    if n==1
        if length(data)>2 
            level1=(length(data)-1);
            level2=1;
        elseif length(data)==2 
            level1=0;
            level2=0;
        else        %this might not be working, I'm not sure...
            disp('No energy levels found in this range')
            fprintf(1,' E1=%10.9f  E2=%10.9f\n',E1(n),E2(n));
            break
        end
    end
    n=n+1;

    if n>40      %just in case...
        break
    end
end
datal=[data((end-level1):(end-level2),1)];


fprintf(1,'This data is only reliable up until the %1.0fth decimal place, \n',precision);
fprintf(1,'as you specified. The following %1.0f energy levels were found  \n', length(datal));
fprintf(1,'by the program Efinder: \n');
fprintf(1,'   \n');
fprintf(1,'   %11.10f  \n',datal);
fprintf(1,'   \n');



fid=fopen('Energy.txt', 'a');     %Saves data from the program to Energy.txt 
fprintf(fid,'This data is only reliable up until the %1.0fth decimal place, \n',precision);
fprintf(fid,'as you specified. The following %1.0f energy levels were found  \n', length(datal));
fprintf(fid,'by the program Efinder: \n');
fprintf(fid,'   \n');
fprintf(fid,'   %11.10f  \n',datal);
fprintf(fid,'   \n');
fclose(fid);
toc


%__________________________________________________________________________

function ydot = schrod(t,y)
%The function schrod stores the Schroedinger equation. 
%Enter the potential below like: 

            %ydot = [y(2);-2*m*(e + (-your potential))*y(1)];

%(e.g. if: potential= -a*((sech(t-l))^2+(sech(t+l))^2)
%then: ydot = [y(2);-2*m*(e +.a*((sech(t-l))^2+(sech(t+l))^2))*y(1)]; )

format long
global e
global pot
global m


ydot = [y(2);-2*m*(e + (     )*y(1)];

