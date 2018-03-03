function [ unc_eig ] = input_decoupling_zeros(A,B)
%Function computes the input decoupling zeros of the state space system
%x'(t)=Ax(t) + Bu(t)
%y(t)=Cx(t)
%i.e. the uncontrollable (non-stabilizable) eigenvalues
eigA=eig(A);
unc_eig=[];
for i=1:length(eigA)
	if rank([eigA(i,1)*eye(length(A))-A B])<length(A)
		unc_eig=[unc_eig; eigA(i,1)];
	end
end
end