# 100 Gauss Legendre points via "FastGaussQuadrature.jl"
const lnodes = [-0.9997137267734413,-0.9984919506395958,-0.9962951347331251,-0.9931249370374434,-0.9889843952429918,-0.983877540706057,-0.9778093584869183,-0.9707857757637063,-0.9628136542558156,-0.9539007829254917,-0.944055870136256,-0.9332885350430795,-0.921609298145334,-0.9090295709825297,-0.895561644970727,-0.8812186793850184,-0.8660146884971647,-0.8499645278795913,-0.8330838798884008,-0.8153892383391763,-0.7968978923903145,-0.7776279096494956,-0.7575981185197073,-0.7368280898020207,-0.7153381175730565,-0.693149199355802,-0.6702830156031411,-0.6467619085141293,-0.6226088602037078,-0.5978474702471789,-0.5725019326213813,-0.5465970120650943,-0.5201580198817632,-0.493210789208191,-0.4657816497733582,-0.43789740217203155,-0.40958529167830166,-0.38087298162462996,-0.3517885263724217,-0.32236034390052926,-0.292617188038472,-0.26258812037150336,-0.23230248184497404,-0.20178986409573646,-0.1710800805386034,-0.1402031372361141,-0.10918920358006115,-0.07806858281343654,-0.046871682421591974,-0.015628984421543188,0.015628984421543188,0.046871682421591974,0.07806858281343654,0.10918920358006115,0.1402031372361141,0.1710800805386034,0.20178986409573646,0.23230248184497404,0.26258812037150336,0.292617188038472,0.32236034390052926,0.3517885263724217,0.38087298162462996,0.40958529167830166,0.43789740217203155,0.4657816497733582,0.493210789208191,0.5201580198817632,0.5465970120650943,0.5725019326213813,0.5978474702471789,0.6226088602037078,0.6467619085141293,0.6702830156031411,0.693149199355802,0.7153381175730565,0.7368280898020207,0.7575981185197073,0.7776279096494956,0.7968978923903145,0.8153892383391763,0.8330838798884008,0.8499645278795913,0.8660146884971647,0.8812186793850184,0.895561644970727,0.9090295709825297,0.921609298145334,0.9332885350430795,0.944055870136256,0.9539007829254917,0.9628136542558156,0.9707857757637063,0.9778093584869183,0.983877540706057,0.9889843952429918,0.9931249370374434,0.9962951347331251,0.9984919506395958,0.9997137267734413,]
const lweights = [0.0007346344905056717,0.001709392653518105,0.0026839253715534818,0.003655961201326376,0.004624450063422119,0.005588428003865517,0.006546948450845323,0.007499073255464713,0.008443871469668972,0.009380419653694457,0.010307802574868971,0.011225114023185977,0.012131457662979496,0.013025947892971542,0.013907710703718773,0.014775884527441305,0.015629621077546,0.016468086176145213,0.01729046056832358,0.018095940722128112,0.018883739613374903,0.019653087494435305,0.02040323264620943,0.021133442112527635,0.021843002416247394,0.02253122025633627,0.02319742318525412,0.02384096026596821,0.024461202707957052,0.025057544481579586,0.025629402910208116,0.026176219239545672,0.02669745918357096,0.02719261344657688,0.027661198220792382,0.02810275565910117,0.028516854322395098,0.028903089601125212,0.029261084110638276,0.029590488059912642,0.029890979593332836,0.030162265105169145,0.030404079526454818,0.030616186583980444,0.03079837903115259,0.03095047885049098,0.03107233742756652,0.031163835696209907,0.031224884254849355,0.03125542345386336,0.03125542345386336,0.031224884254849355,0.031163835696209907,0.03107233742756652,0.03095047885049098,0.03079837903115259,0.030616186583980444,0.030404079526454818,0.030162265105169145,0.029890979593332836,0.029590488059912642,0.029261084110638276,0.028903089601125212,0.028516854322395098,0.02810275565910117,0.027661198220792382,0.02719261344657688,0.02669745918357096,0.026176219239545672,0.025629402910208116,0.025057544481579586,0.024461202707957052,0.02384096026596821,0.02319742318525412,0.02253122025633627,0.021843002416247394,0.021133442112527635,0.02040323264620943,0.019653087494435305,0.018883739613374903,0.018095940722128112,0.01729046056832358,0.016468086176145213,0.015629621077546,0.014775884527441305,0.013907710703718773,0.013025947892971542,0.012131457662979496,0.011225114023185977,0.010307802574868971,0.009380419653694457,0.008443871469668972,0.007499073255464713,0.006546948450845323,0.005588428003865517,0.004624450063422119,0.003655961201326376,0.0026839253715534818,0.001709392653518105,0.0007346344905056717,]

"""
Bivariate standard normal distribution with correlation ρ
"""
struct BiNormal
    ρ::Float64
    ρ̄::Float64
    
    BiNormal(ρ) = new(ρ, sqrt(1-ρ^2))
end
rand(P::BiNormal) = let x = randn(); x, P.ρ*x + P.ρ̄*randn(); end

# Distribution function
Phi(x) = Distributions.cdf(Normal(), x)

# densities
phi(x) = Distributions.pdf(Normal(), x)



# bivariate density
phi(x, y, rho) =  1/(2*pi*sqrt(1-rho^2))*exp(-0.5*(x^2 + y^2 - 2x*y*rho)/(1-rho^2))
# transformed to the interval [-1,1]
phigauss(s, x, y, rho) = (rho)/2 * phi(x, y, 0.5*rho*(s + 1))
# substitute r = sqrt(1-rho^2) for backward integration
function phiback(x, y, r) 
    r̄ = sqrt(1-r^2)
    (1/(2pi*r̄))*exp(-0.5*(x^2 + y^2 - 2x*y*r̄)/r^2)
end
# transformed to the interval [-1,1]
phibackgauss(s, x, y, rho) = 0.5*sqrt(1-rho^2)*phiback(x, y, (sqrt(1-rho^2))*0.5*(s + 1))


function Phi(x, y, ρ) 
    if x == Inf || y == Inf
        Phi(min(x, y))
    elseif x == -Inf || y == -Inf
        0.0
    elseif ρ < -0.95
        Phi(x) - Phi(x, -y, -ρ)
    elseif ρ > 0.95
        Phi(min(x,y)) - sum( lweights[i] * phibackgauss(lnodes[i], x, y, ρ) for i in 1:length(lnodes) )
    else
        Phi(x)*Phi(y) + sum( lweights[i] * phigauss(lnodes[i], x, y, ρ) for i in 1:length(lnodes) )
    end
end

pdf(P::BiNormal, x) = 1/(2*pi*P.ρ̄)*exp(-0.5*(x[1]^2 + x[2]^2 - 2x[1]*x[2]*P.ρ)/(1-P.ρ^2))
cdf(P::BiNormal, x) = Phi(x[1], x[2], P.ρ)

function cdf(P, z)
    if dim(P) == 1
        Distributions.normcdf(P.μ[], sqrt(P.Σ[]), z[])
    elseif dim(P) == 2
        σ1 = sqrt(P.Σ[1,1])
        σ2 = sqrt(P.Σ[2,2])
        ρ = P.Σ[1,2]/(σ1*σ2) 
        x = (z[1] - P.μ[1])/σ1
        y = (z[2] - P.μ[2])/σ2
        Phi(x, y, ρ)
    else 
        error("cdf only for 1 and 2 dimensional Gaussians")
    end
end
    
