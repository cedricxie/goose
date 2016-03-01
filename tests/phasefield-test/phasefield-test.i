[Mesh]
  type = GeneratedMesh
  dim = 2
  nx = 100
  ny = 100
  nz = 0
  zmax = 0
  elem_type = QUAD9
[]

[Variables]
  active = 'phasefield'
  [./phasefield]
    order = FIRST
    family = LAGRANGE
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
    block = 0
    value = 1
  [../]
[]

[BCs]
  active = 'bottom top left right'

  [./bottom]
    type = NeumannBC
    variable = phasefield
    boundary = 'bottom'
    value = 0
  [../]

  [./top]
    type = NeumannBC
    variable = phasefield
    boundary = 'top'
    value = 0
  [../]

  [./left]
    type = DirichletBC
    variable = phasefield
    boundary = 'left'
    value = 1
  [../]

  [./right]
    type = DirichletBC
    variable = phasefield
    boundary = 'right'
    value = 0
  [../]
[]

[Materials]
  [./example]
    type = PhaseFieldDamageModelMaterial
    block = 0
    pfdm_conductivity = 1.0
  [../]
[]

[Executioner]
  type = Steady
  solve_type = 'PJFNK'
[]

[Outputs]
  execute_on = 'timestep_end'
  exodus = true
[]
