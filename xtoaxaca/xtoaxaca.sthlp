{smcl}
{cmd:help xtoaxaca}{right: ({browse "https://doi.org/10.1177/1536867X211025800":SJ21-2: st0640})}
{hline}

{title:Title}

{p2colset 5 17 19 2}{...}
{p2col :{cmd:xtoaxaca} {hline 2}}Longitudinal mean decompositions{p_end}

{pstd}
The {cmd:xtoaxaca} postestimation command provides decomposition techniques
after any kind of regression-based growth curve analysis.  For the programming
of {cmd:xtoaxaca}, Stata 14.1 was used.  Currently, {cmd:xtoaxaca} supports
the analysis of stored models fit using {cmd:reg}, {cmd:xtreg}, or
{cmd:mixed}.


{title:Factor variables}

{pstd}
{cmd:xtoaxaca} relies heavily on the use of factor variables.  Users are
therefore actively encouraged to specify all variables in their regression
command explicitly as factor variables (including noninteracted, continuous
variables).  All variables that are not specified as factor variables are
treated as continuous, and the use of dummy variables is not supported.{p_end} 

{pstd}
The exception to this rule is interactions among decomposition variables.
These must be created as handmade interaction terms (possibly using dummy
variables) and interacted using factor-variable syntax with time and grouping
variables.  Example 3 shows how this can be achieved.{p_end}

{pstd}
The maximum length of variable names for decomposition variables that is
supported by {cmd:xtoaxaca} is 20.


{title:How xtoaxaca works}

{pstd}
A longitudinal decomposition using {cmd:xtoaxaca} works in two steps:

{p 8 11 2}
1. Fit a (growth curve) model.  This model should condition on the variables
that are used as decomposition variables to explain the gap over time between
the groups.

{p 8 11 2}
2. {cmd:xtoaxaca} takes the model and the dataset as input to decompose the
gaps over time using Stata's {cmd:margins} command in the background.


{title:Syntax}

{p 8 16 2}
{cmd:xtoaxaca} {it:varlist}{cmd:,} 
{opth groupvar(varname)} 
{opt groupcat(# #)} 
{opt timevar(varname)} 
{opth times(numlist)} 
{opt model(name)} 
[{opt timeref(#)}  
{opt timebandwidth(#)} 
{opt basemodel(name)}
{opt weights(varname)}
{opt change(changetype)}
{opth normalize(varlist)}
{cmdab:nois:ily}
{cmdab:det:ail}
{cmd:forcesample}
{cmd:twofold(weight}|{cmd:pooled}|{cmd:off)}
{cmd:resultsdata(}[{it:pathname}]{it:filename}[{cmd:, replace}]{cmd:)}
{opt blocks(blockname1 = (varlist1)[, blockname2 = (varlist2) ...])}
{opt tfweight(#)}
{opt fmt(#)}
[{cmdab:nolev:els}|{cmdab:noch:ange}]
{opt seed(#)}
{opt bootstrap(#)}]

{pstd}
{it:varlist} contains all decomposition variables and should include all
variables interacted with the variable specified in {cmd:timevar()}.
Otherwise, the decomposition will be incomplete.  {cmd:estout} (Jann 2004) is
required to run {cmd:xtoaxaca}.


{title:Options}

{phang}
{opth groupvar(varname)} specifies the group variable for decomposition.
{cmd:groupvar()} is required.

{phang}
{opt groupcat(# #)} identifies the group categories in {cmd:groupvar()}
between which differences across time will be decomposed.  Only two codes are
allowed.  {cmd:groupcat()} is required.

{phang}
{opth timevar(varname)} specifies the time variable in the growth curve model.
{cmd:timevar()} is required.

{phang}
{opth times(numlist)} defines the values of {cmd:timevar()} at which group
differences will be decomposed.  {cmd:times()} is required.

{phang}
{opt model(name)} is the name under which the (growth curve) model is stored.
Please ensure that the basic functional form of {cmd:timevar()} and possible
interactions with the {cmd:groupvar()} variable are correctly specified.
Please use factor-variable notation for all variables in the model.
Therefore, do not use dummy variables to represent categorical variables (both
{cmd:timevar()} and {cmd:groupvar()}, as well as decomposition variables), but
use the factor-variable prefix {cmd:i.} instead.  All variables without a
factor-variable prefix are treated as continuous by {cmd:xtoaxaca}.
{cmd:model()} is required.

{phang}
{opt timeref(#)} defines the reference time point for which change
decomposition will be calculated.  This option is required if the option
{cmd:change()} is specified.  It must be one of the time points specified in
{cmd:times()}.

{phang}
{opt timebandwidth(#)} defines the time span around the time points in
{opt times(numlist)} that is used to estimate the time-specific means of the
decomposition variables.  This option is required only if {cmd:timevar()} is
specified as a continuous (factor) variable in the models.  The default is
{cmd:timebandwidth(0.1)}.

{phang}
{opt basemodel(name)} is the name under which an optional baseline model is
stored.  This is not necessary for the decomposition.  It can be used to
ensure that the functional form and interactions of the {cmd:timevar()} with
the grouping variable are correctly specified.  This might be helpful if the
code of {cmd:model()} contains many complicated interactions that might be
prone to errors or typos.  Please use factor-variable notation for all
variables in the baseline model.  Therefore, do not use dummy variables to
represent categorical variables (both {cmd:timevar()} and {cmd:groupvar()}, as
well as decomposition variables).  Instead, use the factor-variable prefix
{cmd:i.}.  All variables without a factor-variable prefix are treated as
continuous by {cmd:xtoaxaca}.

{phang}
{opt weights(varname)} specifies the variable containing (longitudinal)
weights for the estimation of the endowments (means).

{phang}
{opt change(changetype)} specifies the decomposition method of change over
time.  {it:changetype} may be {cmd:interventionist}, {cmd:ssm},
{cmd:smithwelch}, {cmd:wellington}, {cmd:mpjd}, {cmd:kim},
{cmd:interventionist_twofold}, or {cmd:none}.  {cmd:interventionist} yields
the decomposition using the interventionist perspective presented in
Kr{c o:}ger and Hartmann (2021).  {cmd:ssm} gives the simple subtraction
method described in Kim (2010); {cmd:smithwelch} gives the decomposition by
Smith and Welch (1989); {cmd:wellington} gives the decomposition by Wellington
(1993); {cmd:mpjd} gives the Makepeace et al. (1999) decomposition; {cmd:kim}
gives the decomposition presented in Kim (2010). {cmd:interventionist_twofold}
gives the decomposition presented in Kr{c o:}ger and Hartmann (2021) in the
appendix, which is akin to the original twofold Kitagawa-Oaxaca-Blinder
decomposition.  The default is {cmd:change(none)}, which shows only the
decomposition of levels.

{phang}
{opth normalize(varlist)} will normalize the categorical variables according
to the method by Yun (2005).  {it:varlist} may be any categorical variables
from the decomposition {it:varlist}.

{phang}
{opt noisily} yields more output from the in-between estimation steps of, for
example, matrices of means and coefficients over time.  If you specify
{cmd:noisily} with {opt bootstrap()}, you also need to specify
{cmd:resultsdata()}.

{phang}
{opt detail} is the same as {cmd:noisily}.

{phang}
{opt forcesample} forces the command to accept differences in the current
sample in the dataset and the samples used to fit the models.  If a
{cmd:basemodel()} is specified, it also forces {cmd:xtoaxaca} to accept
differences in sample size between {cmd:model()} and {cmd:basemodel()}.  In
normal circumstances, it is not recommended to use this option, and it should
be used only if the output is interpreted according to the differences between
the samples.{p_end}

{phang}
{cmd:twofold(weight}|{cmd:pooled}|{cmd:off)} gives the twofold decomposition
of levels over time.  {cmd:weight} allows the user to specify a weight for the
coefficients.  {cmd:pooled} uses the method proposed by Oaxaca and Ransom
(1994), which is equivalent to a pooled regression model and accounts for the
relative amount of variance in the decomposition variables between the two
groups found in the data.  The default is {cmd:twofold(off)}, which conducts
the threefold decomposition.

{phang}
{cmd:resultsdata(}[{it:pathname}]{it:filename}[{cmd:, replace}]{cmd:)} saves
the main decomposition results in a results dataset that can be used for
further results presentation in tables or graphs.

{phang}
{opt blocks(blockname1 = (varlist1)[, blockname2 = (varlist2) ...])} allows
the calculation of decomposition in blocks of variables.  This is especially
useful together with the {cmd:bootstrap()} option because it will generate
block-specific standard errors.  If you specify {cmd:blocks()}, you also need
to specify {cmd:resultsdata()}.

{phang}
{opt tfweight(#)} specifies the weight that is to be given to the first of the
two groups specified in {opt groupcat(# #)}.  This is allowed only if
{cmd:twofold(weight)} is specified.

{phang}
{opt fmt(#)} specifies the decimal points that are to be used in the results
presentation.

{phang}
{opt nolevels} skips the output of the decomposition of levels.

{phang}
{opt nochange} skips the output of the decomposition of change.

{phang}
{opt seed(#)} specifies the seed for the bootstrapping option.  The default is
the seed currently set in the Stata session.

{phang}
{opt bootstrap(#)} estimates standard errors via bootstrapping with {it:#}
iterations.  In addition to the normal results, it returns an {cmd:e(dec_b)}
and an {cmd:e(dec_V)} matrix for further processing.  If bootstrap clustered
standard errors are to be estimated, the clustering has to be specified in the
original regression command using Stata's {opt cluster(varlist)} option.  If
you specify {cmd:noisily} with {opt bootstrap()}, you also need to specify
{cmd:resultsdata()}.


{title:Example 1: Interventionist decomposition of income trajectories}

{phang}
{cmd:. webuse set  http://xtoaxaca.uni-goettingen.de/}{p_end}
{phang}
{cmd:. webuse xtoaxaca_example}{p_end}

{phang}
{cmd:. xtset id time}

{phang}
{cmd:. * Note that full factor-variable notation is used}.{p_end}
{phang}
{cmd:. xtreg inc i.group##i.time##i.edu c.exp##i.group##i.time}

{phang}
{cmd:. estimates store control}

{phang}
{cmd:. xtoaxaca exp edu, groupvar(group) groupcat(0 1) timevar(time) times(4 2 1) model(control) timeref(2) change(kim)}


{title:Example 2: Contribution of an intervention to change in group differences}

{phang}
{cmd:. webuse set  http://xtoaxaca.uni-goettingen.de/}{p_end}
{phang}
{cmd:. webuse xtoaxaca_example2, clear}

{phang}
{cmd:. xtset id time}

{phang}
{cmd:. quietly eststo cont: xtreg dep i.time##i.group##i.int1 i.time##i.group##i.int2, i(id)}

{phang}
{cmd:. xtoaxaca int1 int2, groupvar(group) groupcat(0 1) timevar(time) times(1 2) timeref(1)  model(cont) change(interventionist)}


{title:Example 3: Interactions of decomposition variables}

{phang}
{cmd:. webuse set  http://xtoaxaca.uni-goettingen.de/}{p_end}
{phang}
{cmd:. webuse xtoaxaca_example, clear}

{phang}
{cmd:. xtset id time}{p_end}

{phang}
{cmd:. * Create interaction term for a squared term}{p_end}
{phang}
{cmd:. replace exp = exp-10}{p_end}
{phang}
{cmd:. generate exp2 = exp*exp}

{phang}
{cmd:. * for interactions among decomposition variables (squared experience) a handmade interaction term is used}{p_end}
{phang}
{cmd:. quietly eststo est3: xtreg inc i.group##i.time##c.(exp exp2) i.group##i.time##i.edu}

{phang}
{cmd:. xtoaxaca edu exp exp2, groupvar(group) groupcat(0 1) timevar(time) nolevels times(4 2 1) model(est3) timeref(2) change(kim) detail normalize(edu)}


{title:Stored results}

{pstd}
When one uses the {cmd:xtoaxaca} command, the results of the original
regression command are retained in Stata's {cmd:e()} format.  Additionally,
the user will find matrices specific to the {cmd: xtoaxaca} command that are
named after the decomposition method chosen (see table 1).

{col 9}Table 1. Overview of stored results after {cmd:xtoaxaca}

{col 9}{hline 60}
{col 9}Method{col 40}Stored results
{col 30}absolute values{col 50}percentages
{col 9}{hline 60}
{col 9}Levels{col 30}{cmd:e(E}|{cmd:C}|{cmd:CE)}{col 50}{cmd:e(pE}|{cmd:pC}|{cmd:pCE)}
{col 9}Simple subtraction
{col 12} method{col 30}{cmd:e(dE}|{cmd:dC}|{cmd:dCE)}{col 50}{cmd:e(pdE}|{cmd:pdC}|{cmd:pdCE)} 
{col 9}Interventionist{col 30}{cmd:e(dE}|{cmd:dC}|{cmd:dCE)}{col 50}{cmd:e(pdE}|{cmd:pdC}|{cmd:pdCE)} 
{col 9}Smith and Welch
{col 12} (1989){col 30}{cmd:e(sw_}{it:X}{cmd:)}{col 50}{cmd:e(psw_}{it:X}{cmd:)}
{col 9}Wellington (1993){col 30}{cmd:e(wl_}{it:X}{cmd:)}{col 50}{cmd:e(pwl_}{it:X}{cmd:)}
{col 9}Makepeace
{col 12}et al. (1999){col 30}{cmd:e(mpjd_}{it:X}{cmd:)}{col 50}{cmd:e(pmpjd_}{it:X}{cmd:)}
{col 9}Kim (2010){col 30}{cmd:e(kim_D}{it:X}{cmd:)}{col 50}{cmd:e(pkim_D}{it:X}{cmd:)}
{col 9}{hline 60}
{col 9}Note: {it:X} stands for the different components within one method.

{pstd}
The {cmd:resultsdata()} option allows users to store the results matrices as a
dataset as well, which can be useful if they are to be presented graphically.
The {cmd:resultsdata()} option will also store all draws from the
bootstrapping procedure if this has been chosen as an option.  There are also
several additional results that are stored by {cmd:xtoaxaca} as described in
table 2.

{col 9}Table 2. Overview of additional results stored after {cmd:xtoaxaca}

{col 9}{hline 68}
{col 9}Name{col 30}Content
{col 9}{hline 68}
{col 9}{cmd:e(cat}{it:X}{cmd:_coef_mean)}{col 30}coefficients for category {it:X} of group variable
{col 9}{cmd:e(cat}{it:X}{cmd:_endow_mean)}{col 30}means of decomposition variables for
{col 32}category {it:X} of group variable
{col 9}{cmd:e(change_model)}{col 30}change in the gap predicted by the model
{col 9}{cmd:e(change_observed)}{col 30}change in the gap as observed in the dataset
{col 9}{cmd:e(means_model)}{col 30}group means predicted by the model
{col 9}{cmd:e(means_observed)}{col 30}group means as observed in the dataset 
{col 9}{cmd:e(prefmat}|{cmd:drefmat)}{col 30}contribution of random effects/fixed effects
{col 32}to the decomposition ({cmd:p} for percentage,
{col 32}{cmd:d} for change) 
{col 9}{cmd:e(summary_levels)}{col 30}summary matrix of level decomposition results 
{col 9}{cmd:e(summary_change)}{col 30}summary matrix of change decomposition results
{col 9}{hline 68}


{title:References}

{phang}
Jann, B. 2004. estout: Stata module to make regression tables. Statistical
Software Components S439301, Department of Economics, Boston College.
{browse "https://ideas.repec.org/c/boc/bocode/s439301.html"}.

{phang}
Kim, C. 2010. Decomposing the change in the wage gap between white and black
men over time, 1980-2005: An extension of the Blinder-Oaxaca decomposition
method. {it:Sociological Methods & Research} 38: 619-651. 
{browse "https://doi.org/10.1177/0049124110366235"}.

{phang}
Kr{c o:}ger, H., and J. Hartmann. 2021. Extending the Kitagawa-Oaxaca-Blinder
decomposition approach to panel data.
{it:Stata Journal} 21: 360-410.{browse "https://doi.org/10.1177/1536867X211025800"}.

{phang}
Makepeace, G., P. Paci, H. Joshi, and P. Dolton. 1999. How unequally has equal
pay progressed since the 1970s? A study of two British cohorts. 
{it:Journal of Human Resources} 34: 534-556. 
{browse "https://doi.org/10.2307/146379"}.

{phang}
Oaxaca, R. L., and M. R. Ransom. 1994. On discrimination and the decomposition
of wage differentials. {it:Journal of Econometrics} 61: 5-21.
{browse "https://doi.org/10.1016/0304-4076(94)90074-4"}.

{phang}
Smith, J. P., and F. R. Welch. 1989. Black economic progress after Myrdal.
{it:Journal of Economic Literature} 27: 519-564.

{phang}
Wellington, A. J. 1993. Changes in the male/female wage gap, 1976-1985.
{it:Journal of Human Resources} 28: 383-411. 
{browse "https://doi.org/10.2307/146209"}.

{phang}
Yun, M.-S. 2005. A simple solution to the identification problem in detailed
wage decompositions. {it:Economic Inquiry} 43: 766-772.
With Erratum, {it:Economic Inquiry} 44: 198. 
{browse "https://doi.org/10.1093/ei/cbi053"}.


{title:Authors}

{pstd}Hannes Kr{c o:}ger{p_end}
{pstd}Socio-Economic Panel (SOEP) Study{p_end}
{pstd}German Institute for Economic Research (DIW){p_end}
{pstd}Berlin, Germany{p_end}
{pstd}{browse "mailto:hkroeger@diw.de":hkroeger@diw.de}{p_end}

{pstd}J{c o:}rg Hartmann{p_end}
{pstd}Georg-August-University G{c o:}ttingen{p_end}
{pstd}G{c o:}ttingen, Germany{p_end}
{pstd}{browse "mailto:joerg.hartmann@sowi.uni-goettingen.de":joerg.hartmann@sowi.uni-goettingen.de}{p_end}


{title:Also see}

{p 4 14 2}
Article:  {it:Stata Journal}, volume 21, number 2: {browse "https://doi.org/10.1177/1536867X211025800":st0640}{p_end}

{p 7 14 2}
Help:  {helpb oaxaca} (if installed){p_end}
