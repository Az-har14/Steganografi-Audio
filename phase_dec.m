function out = phase_dec(signal, L_msg, L)

if nargin < 3
	L = length(signal);
end

m   = 8*L_msg;             
xx = dct(signal);
x   = xx(1:L,1);        
Pi = fft(x);
Phi = angle(Pi);

%membaca data tersembunyi
data = char(zeros(1,m));   
for k=1:m
	if Phi(L/2-m+k)>0
    	data(k)='0';
    else
        data(k)='1';
	end
end
bin = reshape(data(1:m), 8, m/8)';
out = char(bin2dec(bin))';
end