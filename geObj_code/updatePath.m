function params = updatePath(dirRoot,params)

if nargin < 1
    dirRoot = pwd;
end

if nargin < 2
    params = defaultParams(dirRoot);
end


params.trainingImages = [dirRoot '/geObj_code/obj_data/Training/Images/'];
params.trainingExamples = [dirRoot '/geObj_code/obj_data/Training/Images/Examples/'];
params.data = [dirRoot '/geObj_code/obj_data/'];
params.yourData = [dirRoot '/geObj_code/obj_data/yourData/'];
params.tempdir = [dirRoot '/geObj_code/obj_data/tmpdir/'];
params.SS.soft_dir =[dirRoot '/geObj_code/obj_data/segment/'];