function [Y,Xf,Af] = color_net(X,~,~)
%COLOR_NET neural network simulation function.
%
% Generated by Neural Network Toolbox function genFunction, 10-Dec-2014 11:56:36.
% 
% [Y] = color_net(X,~,~) takes these arguments:
% 
%   X = 1xTS cell, 1 inputs over TS timsteps
%   Each X{1,ts} = 4xQ matrix, input #1 at timestep ts.
% 
% and returns:
%   Y = 1xTS cell of 1 outputs over TS timesteps.
%   Each Y{1,ts} = 6xQ matrix, output #1 at timestep ts.
% 
% where Q is number of samples (or series) and TS is the number of timesteps.

%#ok<*RPMT0>

  % ===== NEURAL NETWORK CONSTANTS =====
  
  % Input 1
  x1_step1_xoffset = [2.89514352479452e-14;8.99269892456174e-08;8.99269892456174e-08;2.89514352479452e-14];
  x1_step1_gain = [0.100002388766415;0.100009555857756;0.100009555857756;0.100002388766415];
  x1_step1_ymin = -1;
  
  % Layer 1
  b1 = [1.7372970982839739396;26.775935260551054995;30.887371481297243747;-5.0331984140935190908;-19.508849249453376729];
  IW1_1 = [-2.2510823431082220836 -1.9280352532608531213 -0.56513983502220199728 0.10912570385236725068;-48.046417872402543026 -43.317709502763733553 41.443483506140097461 -26.488543316153990048;-14.19448369402245369 46.417830832253613949 -18.836819215687743423 -6.8053624235008038923;3.3168046387605838454 11.982465708614832067 -1.3898264098738866146 -21.574112707437571146;1.7358412856881875186 18.079710672553101602 14.916625606775426149 -22.81520442119076364];
  
  % Layer 2
  b2 = [-0.84296896428091594444;-0.37263956133492293077;0.090705337886988979257;-0.78326319435216817944;-0.18965714871514413598;-0.85642570338981072187];
  LW2_1 = [-1.2238658012924359397 1.0648754633034540618 0.0030033278234619861791 0.9941750324639007097 -0.99346389040351401611;0.39184685310421607518 -1.0238408192062069535 -0.00012971008903964924633 0.0031287785122274189287 -0.0077368710551533256825;-0.1016878321319903411 0.0070353043181809286899 0.0065055494120443320416 -0.0021815864740382653539 1.0028070189146365276;0.17740212691110202048 -0.0076283052846599606889 -0.37911235067186849212 0.0082370121769466536632 0.013077338520137135602;-0.19293419733340752553 0.0091375062266206442257 -0.63077548106600067612 -0.006803660068564349947 -0.0091519560334488783693;-0.1535049002989876954 0.0074783655413807013923 1.0007395720831659958 -1.0012867898759887364 -0.00098903924582839294888];
  
  % Output 1
  y1_step1_ymin = -1;
  y1_step1_gain = [2;2;2;2;2;2];
  y1_step1_xoffset = [0;0;0;0;0;0];
  
  % ===== SIMULATION ========
  
  % Format Input Arguments
  isCellX = iscell(X);
  if ~isCellX, X = {X}; end;
  
  % Dimensions
  TS = size(X,2); % timesteps
  if ~isempty(X)
    Q = size(X{1},2); % samples/series
  else
    Q = 0;
  end
  
  % Allocate Outputs
  Y = cell(1,TS);
  
  % Time loop
  for ts=1:TS
  
    % Input 1
    Xp1 = mapminmax_apply(X{1,ts},x1_step1_gain,x1_step1_xoffset,x1_step1_ymin);
    
    % Layer 1
    a1 = tansig_apply(repmat(b1,1,Q) + IW1_1*Xp1);
    
    % Layer 2
    a2 = repmat(b2,1,Q) + LW2_1*a1;
    
    % Output 1
    Y{1,ts} = mapminmax_reverse(a2,y1_step1_gain,y1_step1_xoffset,y1_step1_ymin);
  end
  
  % Final Delay States
  Xf = cell(1,0);
  Af = cell(2,0);
  
  % Format Output Arguments
  if ~isCellX, Y = cell2mat(Y); end
end

% ===== MODULE FUNCTIONS ========

% Map Minimum and Maximum Input Processing Function
function y = mapminmax_apply(x,settings_gain,settings_xoffset,settings_ymin)
  y = bsxfun(@minus,x,settings_xoffset);
  y = bsxfun(@times,y,settings_gain);
  y = bsxfun(@plus,y,settings_ymin);
end

% Sigmoid Symmetric Transfer Function
function a = tansig_apply(n)
  a = 2 ./ (1 + exp(-2*n)) - 1;
end

% Map Minimum and Maximum Output Reverse-Processing Function
function x = mapminmax_reverse(y,settings_gain,settings_xoffset,settings_ymin)
  x = bsxfun(@minus,y,settings_ymin);
  x = bsxfun(@rdivide,x,settings_gain);
  x = bsxfun(@plus,x,settings_xoffset);
end
