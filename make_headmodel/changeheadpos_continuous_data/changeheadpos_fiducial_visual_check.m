run ~/startup.m
clear all

data_dir = '/rri_disks/eugenia/meltzer_lab/wenjing_backup/picture_naming/data/proc/14567/'
mot = dlmread(strcat(data_dir, 'pic_onset_PWI.dat'),' ');
na = mot(:,11)'*100;
le = mot(:,12)'*100;
re = mot(:,13)'*100;
dna = na - mean(na);
dle = le - mean(le);
dre = re - mean(re);
runlength = length(re)/3;
runtimes = runlength:runlength:runlength.*2;


figure(1)
subplot(3,1,1)
plot(dna);
%set(gca,'YLim',[-3 3])
subplot(3,1,2)
plot(dle);
subplot(3,1,3)
plot(dre);
vline(runtimes);


mot = dlmread(strcat(data_dir,'pic_onset_overt.dat'),' ');
na = mot(:,11)'*100;
le = mot(:,12)'*100;
re = mot(:,13)'*100;
dna = na - mean(na);
dle = le - mean(le);
dre = re - mean(re);
runlength = length(re)/3;
runtimes = runlength:runlength:runlength.*2;

figure(2)
subplot(3,1,1)
plot(dna);
%set(gca,'YLim',[-3 3])
subplot(3,1,2)
plot(dle);
subplot(3,1,3)
plot(dre);
vline(runtimes);

mot = dlmread(strcat(data_dir,'pic_onset_beginMatch.dat'),' ');
na = mot(:,11)'*100;
le = mot(:,12)'*100;
re = mot(:,13)'*100;
dna = na - mean(na);
dle = le - mean(le);
dre = re - mean(re);
runlength = length(re)/3;
runtimes = runlength:runlength:runlength.*2;

figure(3)
subplot(3,1,1)
plot(dna);
%set(gca,'YLim',[-3 3])
subplot(3,1,2)
plot(dle);
subplot(3,1,3)
plot(dre);
vline(runtimes);