function y=shannon_entro(x)
       [~,N]=size(x);
       y=zeros(1,N);
       for ii=1:N
          sum1=sum(x(:,ii).*log2(x(:,ii)));
          sum1=-1*sum1;
         y(1,ii)=sum1;
       end
      