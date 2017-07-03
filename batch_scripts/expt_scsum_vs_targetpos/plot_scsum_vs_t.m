% Load the data generated by scsum_vs_targetpos.sh runs for
% horizontal movements.
r = struct();
rr = [];
scsum_ar = [];
scsum_sing = [];
lumval=1;

colours = {'r','b','g','k','c','m','r--','b--','g--','k--','c--','m--'};
colcount = 1;

flist = glob('results/r*.dat');
llen = size(flist)(1);
for i = [1 : llen]

    rnm = flist{i};
    resdatname = substr(rnm, 9); % strips initial 'results' string
    resdatname = substr(resdatname, 1, size(resdatname)(2)-4); % Strips '.dat' off
    resdatname = strrep (resdatname, '.', 'p');
    resdatname = strrep (resdatname, '-', 'm');

    load (rnm); % loads struct variable called result
    r = struct_merge (r, result);

    % For expected size of rr, consult sacc_vs_targetpos.m
    sz_2 = size(result.(resdatname))(2);

    if (sz_2 == 14)
        rr = [rr; result.(resdatname)];
    end

    scsum_red = result.([resdatname '_scsum']);
    display('size scsum_red:');
    size(scsum_red)

    scsum_mean = mean(scsum_red, 1); % 1 x 600
    display('size scsum_mean:')
    size(scsum_mean)

    % Mean scsum values - note I put the target position value in
    % col 1 for later sorting.
    scsum_ar = [scsum_ar; result.(resdatname)(2), scsum_mean];

    % Choose row 3 for no strong reason. 1 to 6 is range:
    %    scsum_sing = [scsum_sing; result.(resdatname)(2), scsum_red(3,:)];
end

% The rr array contains these columns:
% thetaX, thetaY, fix_lum, gap_ms, lumval, eyeRxAvg, eyeRyAvg, eyeRzAvg, eyeRxSD, eyeRySD, eyeRzSD, latmean, latsd, dopamine

%
% sort rr on target position value
rr = sortrows(rr,2);

%  Sort on target position value then discard that column:
scsum_ar = sortrows(scsum_ar,1);
scsum_ar = scsum_ar(:,2:end);

%scsum_sing = sortrows(scsum_sing,1);
%scsum_sing = scsum_sing(:,2:end);

% Achieved position (Rot Y)
figure(62);
errorbar (rr(:,2),rr(:,7),rr(:,10),'o-')
hold on;
plot ([-15,-8],[-15,-8], 'g--');
hold off;
xlabel('Target y');
ylabel('eyeRy');
legend(['Lum: ' num2str(rr(1,5)) ' Dopa: ' num2str(rr(1,14))])

% Latency
figure(65);
errorbar (rr(:,2),rr(:,12),rr(:,13),'o-')
xlabel('Target y');
ylabel('Latency (ms)');
legend(['Lum: ' num2str(rr(1,5)) ' Dopa: ' num2str(rr(1,14))]);

% Means of scsum activity for each target
figure(66);
x = [rr(:,2)];
xx = repmat(x, 1, 600);
size(xx)
z = [1:600];
zz = repmat(z, size(x), 1);
size(zz)
size(scsum_ar)
plot3(xx',zz',scsum_ar');
title ('Mean SCSUM activity')
xlabel ('TargY');
ylabel ('time (ms)');
zlabel ('SCSUM activity');

% Selected index activity plot - single SCSUM; just to match with
% the mean plot in figure(66).
%figure(67);
%plot3(xx',zz',scsum_sing');
%title ('Single scsum activity (not means)')
%xlabel ('TargY');
%ylabel ('time (ms)');
%zlabel ('SCSUM activity');

% Sum plot - sum of scsum activity.
scsum_ar2 = scsum_ar(:,200:450);
lsums = sum(scsum_ar2,2);
figure(68);
plot (x,lsums,'bo-');
title ('summed mean scsum activity');
xlabel ('TargY');
ylabel ('summed mean scsum activity');

% Output for Veusz
targrot = [rr(:,2),rr(:,7),rr(:,10)];
f = fopen ('results/sacc_eyery_vs_targ.csv', 'w');
fprintf (f, 'TargY,eyeRy,+-\n');
dlmwrite (f, targrot, '-append');
fclose(f);

latrot = [rr(:,2),rr(:,12),rr(:,13)];
f = fopen ('results/sacc_lat_vs_targ.csv', 'w');
fprintf (f, 'TargY,Latency,+-\n');
dlmwrite (f, latrot, '-append');
fclose(f);