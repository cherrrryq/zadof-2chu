function  position=receive_temp(ReceiveData)
chu_receive = zadoffChuSeq(1,2049);
chu_data_receive(1:2048) = chu_receive(1:2048);
chu_data_receive(2049:4096) = chu_receive(1:2048);
test_data(1:24576) =zeros(1);
test_data = ReceiveData;%test_data(1:2248) = ReceiveData(4097:6344);%test_data(2249:24576) = ReceiveData(1:22328);
for   index_conpare_tet = 1:6
xcorr_test = test_data(1:4096);
test_data =  test_data(4097:end);
xcorr_test_a = xcorr(xcorr_test); 
xcorr_test_b = xcorr(xcorr_test,chu_data_receive);
final_a(:,index_conpare_tet) =  abs(xcorr_test_a);
final_b(:,index_conpare_tet) =  abs(xcorr_test_b);
end
final_test_a = final_a(:);
final_test_b = final_b(:);
count_zeros= zeros(1);
for index_length = 1:length(final_test_b)-1 
if final_test_b(index_length) < 0.001 && final_test_b(index_length+1) < 0.001 
    count_zeros = count_zeros +1;   % 这个值：如果经过信道后，有数据丢失，那么此值可有意义
end
end
data_length_count_zeros = length(final_test_b);
position_temp(1:49146) = zeros(1);
[pks_temp,locs_temp] = findpeaks(final_test_b,'MinPeakDistance',2000);   %参数1
length_pks = length(pks_temp);
mean_pks = mean(pks_temp);
   
   for i_pks = 1:length_pks
       if pks_temp(i_pks)>mean_pks*0.5  %参数2
           position_pks_temp = locs_temp(i_pks);
           position_pks(i_pks) = position_pks_temp;
       end
   end
   position_pks(find(position_pks==0))=[];
   data_position_fix = fix(position_pks(2)/8192);
   data_position = position_pks(2) - data_position_fix*4095;
   data_position_data1 = position_pks(1) - data_position_fix*4095;
   position = zeros(1);
 
   if data_position ~=0
       position = data_position + 1;
   else
       position =[];
       fprintf('同步失败');
   end

   
end
