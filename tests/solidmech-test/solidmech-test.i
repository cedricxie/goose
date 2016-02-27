[Mesh]
  file = 1x1x1cube.e
  
  # 2 - back
  # 3 - bottom
  # 4 - left
  # 5 - top
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
[]

[SolidMechanics]
  [./structure]
    disp_x = disp_x
    disp_y = disp_y
    disp_z = disp_z
  [../]
[]

[Kernels]
[]

[Functions]
  [./top_pull]
    type = ParsedFunction
    value = t*(0.01)
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
[]

[BCs]
  [./y_pull_function]
    type = FunctionPresetBC
    variable = disp_y
    boundary = 5
    function = top_pull
  [../]

  [./x_bot]
    type = PresetBC
    variable = disp_x
    boundary = 4
    value = 0.0
  [../]

  [./y_bot]
    type = PresetBC
    variable = disp_y
    boundary = 3
    value = 0.0
  [../]

  [./z_bot]
    type = PresetBC
    variable = disp_z
    boundary = 2
    value = 0.0
  [../]

[]

[Materials]
  [./pmma]
    type = Elastic
    block = 1
    youngs_modulus = 2.483e9 #Pa
    poissons_ratio = 0.33
    formulation = Linear
    
    disp_x = disp_x
    disp_y = disp_y
    disp_z = disp_z
  [../]
[]

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
  nl_rel_tol = 1e-12
  nl_abs_tol = 1e-10
  l_tol = 1e-9

  start_time = 0.0
  end_time = 1
  dt = 0.01
[]

[Postprocessors]
  [./stress_yy]
    type = ElementalVariableValue
    elementid = 0
    variable = stress_yy
  [../]
  [./strain_yy]
    type = ElementalVariableValue
    elementid = 0
    variable = strain_yy
  [../]
[]

[Outputs]
  [./exodus]
    type = Exodus
    #Outputs the result to an exodus file and converts the element stress output to a nodal output
    #elemental_as_nodal = true
  [../]
[]
