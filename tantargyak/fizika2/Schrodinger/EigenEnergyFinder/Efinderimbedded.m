function Efinder
tic    

%Efinder: In this example, Efinder is imbedded in for loops to find the 
%eigen energies for double-well potential. Note: hbar has been scaled to 1.

%To use: =>run 

%__________________________________________________________________________

%  2*ep*((sech(t-l/2))^2+(sech(t+l/2))^2))     (double-well potential)

%In this example file, Efinder will find the eigen energies for the potential
%shown above, which is a potential encountered when considering a fluxon trapped 
%in a double-well potential in a long Josephson Junction. The resulting 
%Schroedinger equation is a differential that has yet to be solved exactly to
%find a formulaic expression for the Energy and thus must be solved
%numerically.

%In this case, the variable epsilon scales the depth or strength of the
%potential well(s) the fluxon is trapped in--the deeper the well, the more
%energy levels will be contained in it--and l corresponds to the separation 
%of the minima of the potential wells. In this example, l=linspace(1,3,20)
%to explore the behavior of the energy levels as this separation changes.
%The t used above corresponds to position.

%The data will be saved to a file called Energy.txt in your workspace. The 
%data should be straightforward as far as the l and epsilon for each set of 
%data is concerned, but it will say nothing about which energy level is
%which (i.e. ground state,...).

%Furthermore, as l increases the energy levels often get too close together 
%for the program to 'see' them, and therefore it no longer collects data for 
%those two particular energy levels and leaves a gap in the data from this
%point on. This is due to the energy step size, 'steps', being larger than
%energy difference between the two energy levels. This can be corrected by
%increasing the step size, but by doing this the program takes longer.
%Data for this gap can also be collected after the fact by running the
%while loop again using the last collected energy levels as the initial
%range of energies that the subsequent 'for' loop considers (which would
%then use much smaller increments). The step size has been set to an
%appropriate level for this example, but this of course can be changed. 

%Efinder will also display the data as 'dataep' in your command window when
%the program is done, but this will be in a less user friendly format, as
%follows:

%datal=[datal;l 0;ep 0;data((end-level1):(end-level2),:);zeros(4,2)]; 

%which is then dumped into dataep as follows:

%dataep=[dataep;datal(:,1);ones(6,1)].

%Datal collects all of the raw data and attaches the l and epsilon to it, then
%separates each set of energy levels for each l by 4 zeros. Then after all
%the l's for one epsilon are completed and just before it switches to the
%next epsilon, datal is dumped into dataep and then datal is reset (datal=[]). 
%Dataep takes only the first column of datal and separates each new datal 
%(new epsilon) from the last with 6 ones.

%Other explanations can be found in the body of this file.



%I make no claim that there is not a better way to find the eigen energies
%that satisfy the Schroedinger equation, but using this technique that takes 
%advantage of the wave solution behavior, as this program does, the energy 
%levels for 'nearly' any potential (I say 'nearly' because I have not tried 
%them all!) can be ascertained numerically. 

%I hope this explanation is adequate, but if there are any questions or 
%suggestions feel free to contact me at <isaac.obryant@und.nodak.edu>.

%%Efinder was created by Isaac O'Bryant with help from Ramesh Dhungana. 
%Physics, University of North Dakota,(c) 7/29/2005

%__________________________________________________________________________



format long
global e
global l
global ep
global precision



precision=6;      
           
dataep=[];
fval=0;
tt=-6:.01:6;
options= odeset('RelTol', 1e-10,'AbsTol',[1e-10 1e-10]);
y0 = [0;1];
tspan = [-40,40];    %this is set at an appropriate level for this example
                     %such that the endpoint of the wave solution will shoot
                     %off to either positive or negative infinity, unless the
                     %E used from the while loop was very close to an allowed 
                     %energy


fid=fopen('Energy.txt', 'a');     %Saves data from the program to Energy.txt 
fprintf(fid,'Note this data is only good up until the %1.0fth decimal place, \n',precision);
fprintf(fid,'as you specified.   \n');
fprintf(fid,'   \n');
fprintf(fid,'   \n');
fprintf(fid,'   \n');
fclose(fid);

for ep=[.21,.33]      %here's where you set the epsilon-here's a few random ones
	datal=[];         
    
    fid=fopen('Energy.txt', 'a');
    fprintf(fid,'   \n');
    fprintf(fid,'   \n');
    fprintf(fid,'Energy levels for epsilon = %5.4f \n',ep);
    fprintf(fid,'   \n');
    fclose(fid);   

    
	for l=linspace(2.2,3.1,20)     %here's where you set the separation lengths 
		ee=[0;1];
		n=1;
		data=[0 0];
		pot=-2*ep*((sech(tt-l/2)).^2+(sech(tt+l/2)).^2);
		potbottem=min(pot); %this finds the bottem of the potential well(s)
                            %which will be used in the first iterations of 
                            %the while loop below
        
        while (abs(ee(end-1)-ee(end))>(1*10^(-1-precision))) | ((ee(end-1)-ee(end))==0)
			E1=[fval;data(:,1)];        %the first range it looks at is from the bottem 
			E2=[potbottem;data(:,2)];   %of the potential well to 0 (fval=0)
			previous=[];
			t=[];
			y=[];

			if n>1
				steps=20;   %after it finds some energy levels, it switches to this stepsize
                            %and defines the energy levels more accurately each time it goes
                            %through the while loop
			else
				steps=300;  %the first iteration it looks through the whole range and finds 
                            %all the energy levels
			end
	
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
                    k=0;
                elseif length(data)==2 
                    level1=0;
					level2=0;
                    k=0;
                else
                    k=1;
                end
            end
            
            if k==1
                disp('No data for the following l') 
                l
				disp('for these E1 and E2')
                E1
                E2
                
                fid=fopen('Energy.txt', 'a');
                fprintf(fid,'No data was found for l= %6.5f and between\n',l);
                fprintf(fid,'these energies: E1=%10.9f  E2=%10.9f\n',E1,E2);
                fprintf(fid,'   \n');
                fprintf(fid,'   \n');
                fclose(fid);
                
                break
            end
				
			n=n+1;
					
			if n>40
				break
			end
        end
        
        datal=[datal;l 0;ep 0;data((end-level1):(end-level2),:);zeros(4,2)];
        b=data((end-level1):(end-level2),:);
        
        fid=fopen('Energy.txt', 'a');
        fprintf(fid,'ep= %5.4f and l= %7.6f \n',ep,l);
        fprintf(fid,'   %11.10f  \n',b);
        fprintf(fid,'   \n');
        fclose(fid);
    end	 
    
dataep=[dataep;datal(:,1);ones(6,1)];
end

dataep
toc

%_________________________________________________________________________

function ydot = schrod(t,y)
% The fuction schrod stores the Schroedinger equation with the double
% potential well. This will be called while solving SE.
format long
global e
global l
global ep

m = 8; 
ydot = [y(2);-2*m*(e + 2*ep*((sech(t-l/2))^2+(sech(t+l/2))^2))*y(1)];

