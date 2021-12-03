%   File: IMCCA_GenEmpiricalDistribution.m
%   Copyright (c) <2018> <University of Paderborn>
%   Permission is hereby granted, free of charge, to any person
%   obtaining a copy of this software and associated documentation
%   files (the "Software"), to deal in the Software without restriction,
%   including without limitation the rights to use, copy, modify and
%   merge the Software, subject to the following conditions:
%
%   1.) The Software is used for non-commercial research and
%       education purposes.
%
%   2.) The above copyright notice and this permission notice shall be
%       included in all copies or substantial portions of the Software.
%
%   3.) Publication, Distribution, Sublicensing, and/or Selling of
%       copies or parts of the Software requires special agreements
%       with the University of Paderborn and is in general not permitted.
%
%   4.) Modifications or contributions to the software must be
%       published under this license. The University of Paderborn
%       is granted the non-exclusive right to publish modifications
%       or contributions in future versions of the Software free of charge.
% 
%   THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
%   EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
%   OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
%   NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
%   HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
%   WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
%   FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
%   OTHER DEALINGS IN THE SOFTWARE.
%
%   Persons using the Software are encouraged to notify the
%   Signal and System Theory Group at the University of Paderborn
%   about bugs. Please reference the Software in your publications
%   if it was used for them.
% ------------------------------------------------------------------------
% SYNTAX:   
%
% [empEvals] =  IMCCA_GenEmpiricalDistribution(p,n_sets,M,tot_dims,...
%               emp_dist_iters)
%
% OVERVIEW: 
%
% Generates an empirical eigenvalue distibution for the IMCCA method.
%       
% INPUTS:
%
%                   
% OUTPUTS:  
%
% 'empEvals'
%
% DEPENDENCIES:
%
% MultisetDataGen_CorrMeans.m
%       
% REFERENCES:
%
% IMCCA method:
% [1]   Asendorf, Nicholas, and Raj Rao Nadakuditi. "Improving multiset 
%       canonical correlation analysis in high dimensional sample 
%       deficient settings." In Signals, Systems and Computers, 2015 
%       49th Asilomar Conference on, pp. 112-116. IEEE, 2015. Harvard
%
% ------------------------------------------------------------------------
% CREATED:      21/02/2018 by Tim Marrinan
%
% LAST EDITED:  21/02/2018 by Tim Marrinan
%               
% NOTES: 
%
% ------------------------------------------------------------------------
function [empEvals] =  IMCCA_GenEmpiricalDistribution(n_sets,M,tot_dims,...
    sigmaN,emp_dist_iters)

empEvals = zeros(emp_dist_iters,n_sets*tot_dims);
subspace_dims = repmat(tot_dims, [1, n_sets]);
for j = 1 : emp_dist_iters
    N = cell(n_sets,1);
    un = cell(n_sets,1);
    emp_meta = zeros(M,tot_dims*n_sets);
    for i = 1 : n_sets
        N{i} = sqrt(sigmaN)*randn(subspace_dims(i),M); % Noise in the ith channel
        [un{i},~,~] = svd(N{i}',0);
        emp_meta(:,((i-1)*tot_dims)+1:i*tot_dims) = un{i};
    end
    empEvals(j,:) = max(svd(emp_meta,0)-1 ,0);
end