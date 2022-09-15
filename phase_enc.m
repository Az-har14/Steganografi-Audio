function out = phase_enc(signal, text, L)

if nargin < 3
	L = length(signal);
end

plan = dct(signal);
plain = plan(:,1);
data = getBits(text);
I = length(plain);
m = length(data);      % panjang bit data yang akan disembunyikan
N = floor(I/L);        % banyaknya frame

s = reshape(plain(1:N*L,1), L, N);  

w = fft(s);            
Phi = angle(w);        
A = abs(w);            

DeltaPhi = zeros(L,N);
for k=2:N
	DeltaPhi(:,k)=Phi(:,k)-Phi(:,k-1); 
end

PhiData = zeros(1,m);
for k=1:m
	if data(k) == '0'
        PhiData(k) = 1;
    else
        PhiData(k) = -1;
	end
end

% PhiData dimasukkan ke bagian tengah matriks
Phi_new(:,1) = Phi(:,1);
Phi_new(L/2-m+1:L/2,1) = PhiData;             
Phi_new(L/2+1+1:L/2+1+m,1) = -flip(PhiData);  

% menyusun ulang matriks
for k=2:N
	Phi_new(:,k) = Phi_new(:,k-1) + DeltaPhi(:,k);
end

% Mengembalikan data sinyal audio menggunanakan ifft
z = real(ifft(A .* exp(1i*Phi_new)));    
snew = reshape(z, N*L,1);
res  = [snew plain(N*L+1:I)];           
out = idct(res);
end