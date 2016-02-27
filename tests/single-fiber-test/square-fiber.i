[Mesh]
  file = square-fiber.e
  
  boundary_id = '1 2 3 4 5 6 7' #Assign names to boundaries to make things clearer
  boundary_name = 'front top right back left bottom inner'

  # 1 - front
  # 2 - top
  # 3 - right
  # 4 - back
  # 5 - left
  # 6 - bottom
  # 7 - inner
[]

[Variables]
  [./disp_x]
    order = FIRST
    family = LAGRANGE
  [../]
  [./disp_y]
    order = FIRST
    family = LAGRANGE
  [../]
  [./disp_z]
    order = FIRST
    family = LAGRANGE
  [../]
  
  [./phasefield]
    order = FIRST
    family = LAGRANGE
    #initial_condition = 1.0
  [../]
[]

[AuxVariables]
  [./stress_xx]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./stress_xy]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./stress_yy]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./stress_zz]
    order = CONSTANT
    family = MONOMIAL
  [../]

  [./strain_xx]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./strain_xy]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./strain_yy]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./strain_zz]
    order = CONSTANT
    family = MONOMIAL
  [../]
  [./elastic_energy_density]
    order = CONSTANT
    family = MONOMIAL
  [../]
[]
################################################################
#KERNELS
################################################################
[SolidMechanics]
  [./structure]
    disp_x = disp_x
    disp_y = disp_y
    disp_z = disp_z
    #pf = phasefield
  [../]
[]

[Kernels]
  [./pfdm]
    type = PhaseFieldDamageModel
    variable = phasefield
  [../]
  [./source]
    type = PhaseFieldDamageModelSource
    variable = phasefield
    block = 1

    fracture_toughness = 480
    l0 = 3e-5

    initial_youngs_modulus = 2.483e9 #Pa
    poissons_ratio = 0.33
    disp_x = disp_x
    disp_y = disp_y
    disp_z = disp_z
  [../]
[]

[Materials]
  [./pmma_structural]
    type = Elastic
    block = 1
    initial_youngs_modulus = 2.483e9 #Pa
    poissons_ratio = 0.33
    formulation = Linear
    
    disp_x = disp_x
    disp_y = disp_y
    disp_z = disp_z
    
    pf = phasefield
  [../]
  [./pmma_damage]
    type = PhaseFieldDamageModelMaterial
    block = 1
    pfdm_conductivity = 3.6e-9
  [../]
[]
################################################################
#BOUNDARY CONDITIONS
################################################################
[ICs]
  [./phase_field_ic]
    type = PhaseFieldDamageModelIC
    variable = phasefield
    coefficient = 1.0
    block = 1
  [../]
[]

[Functions]
  [./top_pull]
    type = ParsedFunction
    value = t*(0.03)
  [../]
[]

[AuxKernels]
  [./stress_xx]
    type = MaterialTensorAux
    tensor = stress
    variable = stress_xx
    index = 0
  [../]
  [./stress_xy]
    type = MaterialTensorAux
    tensor = stress
    variable = stress_xy
    index = 3
  [../]
  [./stress_yy]
    type = MaterialTensorAux
    tensor = stress
    variable = stress_yy
    index = 1
  [../]
  [./stress_zz]
    type = MaterialTensorAux
    tensor = stress
    variable = stress_zz
    index = 2
  [../]

  [./strain_xx]
    type = MaterialTensorAux
    tensor = total_strain
    variable = strain_xx
    index = 0
  [../]
  [./strain_xy]
    type = MaterialTensorAux
    tensor = total_strain
    variable = strain_xy
    index = 3
  [../]
  [./strain_yy]
    type = MaterialTensorAux
    tensor = total_strain
    variable = strain_yy
    index = 1
  [../]
  [./strain_zz]
    type = MaterialTensorAux
    tensor = total_strain
    variable = strain_zz
    index = 2
  [../]
  [./elastic_energy_density]
    type = ElasticEnergyAux
    variable = elastic_energy_density
  [../]
[]

[BCs]
  [./structure_top]
    type = FunctionPresetBC
    variable = disp_y
    boundary = top
    function = top_pull
  [../]

  [./structure_bottom]
    type = PresetBC
    variable = disp_y
    boundary = bottom
    value = 0.0
  [../]

  [./structure_left]
    type = PresetBC
    variable = disp_x
    boundary = left
    value = 0.0
  [../]

  [./structure_right]
    type = PresetBC
    variable = disp_x
    boundary = right
    value = 0.0
  [../]
 
  [./structure_inner_x]
    type = PresetBC
    variable = disp_x
    boundary = inner
    value = 0.0
  [../]

  [./structure_inner_y]
    type = PresetBC
    variable = disp_y
    boundary = inner
    value = 0.0
  [../]

  [./structure_inner_z]
    type = PresetBC
    variable = disp_z
    boundary = inner
    value = 0.0
  [../]

  [./structure_front]
    type = PresetBC
    variable = disp_z
    boundary = front
    value = 0.0
  [../]

  [./structure_back]
    type = PresetBC
    variable = disp_z
    boundary = back
    value = 0.0
  [../]

  [./pfdm_top]
    type = NeumannBC
    variable = phasefield
    boundary = top
    value = 0.0
  [../]

   [./pfdm_bottom]
    type = NeumannBC
    variable = phasefield
    boundary = bottom
    value = 0.0
  [../]

  [./pfdm_left]
    type = NeumannBC
    variable = phasefield
    boundary = left
    value = 0.0
  [../]

  [./pfdm_right]
    type = NeumannBC
    variable = phasefield
    boundary = right
    value = 0.0
  [../]

  [./pfdm_inner]
    type = PresetBC
    variable = phasefield
    boundary = inner
    value = 1.0
  [../]
[]
################################################################
#SOLVER
################################################################
[Executioner]
  type = Transient

  #Preconditioned JFNK (default)
  solve_type = 'PJFNK'


  petsc_options = '-ksp_snes_ew'
  petsc_options_iname = '-ksp_gmres_restart -pc_type -pc_hypre_type -pc_hypre_boomeramg_max_iter'
  petsc_options_value = '201                hypre    boomeramg      4'


  line_search = 'none'


  l_max_its = 100
  nl_max_its = 100
  nl_rel_tol = 1e-8
  nl_abs_tol = 1e-6
  l_tol = 1e-6

  start_time = 0.0
  end_time = 1
  dt = 1e-2
[]
################################################################
#OUTPUTS
################################################################
[Postprocessors]
  [./stress_yy]
    type = ElementalVariableValue
    elementid = 0
    variable = stress_yy
  [../]
  [./strain_xx]
    type = ElementalVariableValue
    elementid = 0
    variable = strain_xx
  [../]
  [./strain_yy]
    type = ElementalVariableValue
    elementid = 0
    variable = strain_yy
  [../]
  [./strain_zz]
    type = ElementalVariableValue
    elementid = 0
    variable = strain_zz
  [../]
  [./phasefield]
    type = ElementalVariableValue
    elementid = 0
    variable = phasefield
  [../]
  [./elastic_energy_density]
    type = ElementalVariableValue
    elementid = 0
    variable = elastic_energy_density
  [../]
[]

[Outputs]
  [./exodus]
    type = Exodus
    #Outputs the result to an exodus file and converts the element stress output to a nodal output
    #elemental_as_nodal = true
  [../]
[]
