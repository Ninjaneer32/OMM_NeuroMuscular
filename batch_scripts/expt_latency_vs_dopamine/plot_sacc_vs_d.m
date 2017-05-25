% Load the data generated by sacc_lat_vs_dop.sh runs
r = struct();
rr = [];

colours = {'r','b','g','k','c','m','r--','b--','g--','k--','c--','m--'};

flist = glob('results/r*.dat');
llen = size(flist)(1);
for i = [1 : llen]

    rnm = flist{i}
    resdatname = substr(rnm, 9); % strips initial 'results/' string
    resdatname = substr(resdatname, 1, size(resdatname)(2)-4); % Strips '.dat' off
    resdatname = strrep (resdatname, '.', 'p');
    resdatname = strrep (resdatname, '-', 'm');

    load (rnm); % loads struct variable called result
    r = struct_merge (r, result);

    % For expected size of rr, consult sacc_vs_targetpos.m
    size(rr);
    sz_2 = size(result.(resdatname))(2)

    if (sz_2 >= 13)
        rr = [rr; result.(resdatname)];
    else
        display('Not the right size');
    end

end

% The rr array contains these columns:
% thetaX, thetaY, gap_ms, lum, eyeRxAvg, eyeRyAvg, eyeRzAvg, eyeRxSD, eyeRySD, eyeRzSD, latmean, latsd
%
% sort rr on dopamine
rr = sortrows(rr,13)

% Sort also by luminance (col 4) and separate out into lat vs. gap
% for differing luminances.
luminances = unique(rr(:,4));

% lat vs dopamine
figure(32);
clf;
legend_str='';
colcount = 1;
for l = luminances'
    l
    rr_1 = [];
    rr_1 = rr(find(rr(:,4)==l),:);
    errorbar (rr_1(:,13),rr_1(:,11),rr_1(:,12), colours{colcount})
    hold on;
    legend_str = [legend_str; num2str(l)];
    colcount = colcount + 1;
end
xlabel('dopamine');
ylabel('Latency (ms)');
legend(legend_str);