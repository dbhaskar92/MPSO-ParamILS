% 
% Generate scatter plot to assess performance of configured MSPO input parameters vs. default 
%
% Author:
%   Dhananjay Bhaskar
%
% Last modified:
%   Sunday, May 01, 2016
%

func_name = 'WeierstrassW2';
xmin = -0.5;
xmax = 0.5;
true_min = -83;
errgoal = 1;
cutoff_length = 400000;

numRuns = 10;
seed = 123;

ConfigDef = zeros(numRuns,2);
ConfigILS0 = zeros(numRuns,2);
ConfigILS1 = zeros(numRuns,2);
ConfigILS2 = zeros(numRuns,2);

for i = 1 : numRuns

	% default configuration
	c1 = 2.05;
	c2 = 2.05;
	rad = 1;
	lbd = 1.0;
	tmax = 5;

	[~, ~, ConfigDef(i,1), ConfigDef(i,2)] = MPSO(func_name,xmin,xmax,true_min,errgoal,cutoff_length,seed,c1,c2,rad,lbd,tmax);
	
	if ConfigDef(i,1) > 400000
		ConfigDef(i,1) = 400000;
	end
	
	% ParamILS Run 0 configuration
	c1 = 2.05;
	c2 = 2.15;
	rad = 3;
	lbd = 0.8;
	tmax = 5;
	
	[~, ~, ConfigILS0(i,1), ConfigILS0(i,2)] = MPSO(func_name,xmin,xmax,true_min,errgoal,cutoff_length,seed,c1,c2,rad,lbd,tmax);
	
	if ConfigILS0(i,1) > 400000
		ConfigILS0(i,1) = 400000;
	end
	
	% ParamILS Run 1 configuration
	c1 = 2.075;
	c2 = 2.05;
	rad = 5;
	lbd = 0.5;
	tmax = 5;
	
	[~, ~, ConfigILS1(i,1), ConfigILS1(i,2)] = MPSO(func_name,xmin,xmax,true_min,errgoal,cutoff_length,seed,c1,c2,rad,lbd,tmax);
	
	if ConfigILS1(i,1) > 400000
		ConfigILS1(i,1) = 400000;
	end

	% ParamILS Run 2 configuration
	c1 = 2.1;
	c2 = 2.1;
	rad = 2;
	lbd = 0.8;
	tmax = 12;
	
	[~, ~, ConfigILS2(i,1), ConfigILS2(i,2)] = MPSO(func_name,xmin,xmax,true_min,errgoal,cutoff_length,seed,c1,c2,rad,lbd,tmax);
	
	if ConfigILS2(i,1) > 400000
		ConfigILS2(i,1) = 400000;
	end
    
    seed = seed + 1;

end

x = 1:1:400000;
y = 400000.*ones(400000,1);

figure
grid on
set(gca,'fontsize',11)
scatter(ConfigDef(:,1),ConfigILS0(:,1),25,'r','filled')
hold on
scatter(ConfigDef(:,1),ConfigILS1(:,1),25,'g','filled')
hold on
scatter(ConfigDef(:,1),ConfigILS2(:,1),25,'b','filled')
hold on
plot(x,x,'color','k')
hold on
plot(x,y,'color','k')
hold on
plot(y,x,'color','k')
set(gca,'xscale','log')
set(gca,'yscale','log')
axis([1,500000,1,500000])
title('Runlengths for Shifted Rotated Weierstrass Function (10 ind. runs)')
xlabel('log10 of FEvals for Default Configuration')
ylabel('log10 of FEvals for ParamILS Configuration')
l = legend('Run 0','Run 1','Run 2');
set(l,'Location','southwest');

figure
grid on
set(gca,'fontsize',11)
scatter(ConfigDef(:,2),ConfigILS0(:,2),25,'r','filled')
hold on
scatter(ConfigDef(:,2),ConfigILS1(:,2),25,'g','filled')
hold on
scatter(ConfigDef(:,2),ConfigILS2(:,2),25,'b','filled')
title('Runtime for Shifted Rotated Weierstrass Function (10 ind. runs)')
xlabel('Runtime for Default Configuration')
ylabel('Runtime for ParamILS Configuration')
l = legend('Run 0','Run 1','Run 2');
set(l,'Location','northeast');
