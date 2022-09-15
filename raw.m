function audio_raw = raw(signal, L_msg, L)

if nargin < 3
	L = length(signal);
end

plan = dct(signal);
plain = plan(:,1);
I = length(plain);
m   = 8*L_msg;             % Length of bit sequence (for 8bit)
N = floor(I/L);        % Number of frames (for 8 bit)

s = reshape(plain(1:N*L,1), L, N);  % Dividing audio file into segments

w = fft(s);            
Phi = angle(w);        
A = abs(w);            

x = plan(1:L,1);
xx = fft(x);
pi = angle(xx);

DeltaPhi = zeros(L,N);
for k=2:N
	DeltaPhi(:,k)=Phi(:,k)-Phi(:,k-1); 
end

data = zeros(1,m);
Phi_new(:,1) = Phi(:,1);
new = Phi_new(L/2-m+1:L/2,1);
for k=1:m
    pi(L/2-m+k);
    data(k)=pi(L/2-m+k);
    %disp(data(k));
    %disp(Phi_new(L/2-m+1:L/2,1));
    if isequal(new(k),data(k))
        new(k) = 0;
    else
        disp('fail');
    end
end
    Phi_new(L/2-m+1:L/2,1) = new;

for k=2:N
	Phi_new(:,k) = Phi_new(:,k-1) + DeltaPhi(:,k);
end

% Reconstructing the sound signal by applying the inverse FFT
z = real(ifft(A .* exp(1i*Phi_new)));    % Using Euler's formula
snew = reshape(z, N*L, 1);
res  = [snew plain(N*L+1:I)];           % Adding rest of signal
%res = [res1 plan(:,2)]; 
audio_raw = idct(res);
end