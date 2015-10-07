# GOOGLECHARTS ========================================================================================================

# https://github.com/jverzani/GoogleCharts.jl

using GoogleCharts
using RDatasets

arrests = dataset("datasets", "USArrests");

arrests[:Murder]  = arrests[:Murder]  ./ arrests[:UrbanPop]
arrests[:Assault] = arrests[:Assault] ./ arrests[:UrbanPop]
arrests[:Rape]    = arrests[:Rape]    ./ arrests[:UrbanPop]

delete!(arrests, :UrbanPop)

options = {:title => "Violent Crimes",
           :hAxis =>  {:title => "State"},    
           :vAxis =>  {:title => "Incidents per Capita"}
}

chart = scatter_chart(arrests, options);

render(chart)
