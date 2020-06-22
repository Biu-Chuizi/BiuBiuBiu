filename = 'data_LST-8_map.mat';
load(filename, 'm');
k = keys(m);
n = containers.Map;
for i=1:length(k)
    v = m(k{i});
    [foo, k_new, bar] = fileparts(k{i});
    n(k_new) = v;
end
m = n;
save('data_LST-8_map_1', 'm');