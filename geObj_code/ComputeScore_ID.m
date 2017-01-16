function score_id = ComputeScore_ID(img, x_sal, segment, spInWin, boxes)

dir_root = pwd;%change this to an absolute path

try            
    struct = load([dir_root '/geObj_code/obj_data/params.mat']);
    params = struct.params;
    clear struct;
catch
    params = defaultParams(dir_root);
    save([dir_root '/geObj_code/obj_data/params.mat'],'params');
end

params = updatePath(dir_root,params);

% score_id = ImgDepScore_SP(x_sal, segment, .5, spInWin, allboxes);
params.cues = params.cues(2:3); % drop saliency

score = zeros(size(boxes,1),length(params.cues));
% score(:,1) = ImgDepScore_SP(x_sal, segment, .5, spInWin, boxes);
windows = boxes(:,1:4);
for idx = 1:length(params.cues)
    temp = computeScores(img,params.cues{idx},params,windows);
    score(:,idx) = temp(:,end);       
end
score_id = integrateBayes(params.cues,score,params);    
