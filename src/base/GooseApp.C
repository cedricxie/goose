#include "GooseApp.h"
#include "Moose.h"
#include "AppFactory.h"
#include "ModulesApp.h"
#include "MooseSyntax.h"

template<>
InputParameters validParams<GooseApp>()
{
  InputParameters params = validParams<MooseApp>();

  params.set<bool>("use_legacy_uo_initialization") = false;
  params.set<bool>("use_legacy_uo_aux_computation") = false;
  params.set<bool>("use_legacy_output_syntax") = false;

  return params;
}

GooseApp::GooseApp(InputParameters parameters) :
    MooseApp(parameters)
{
  Moose::registerObjects(_factory);
  ModulesApp::registerObjects(_factory);
  GooseApp::registerObjects(_factory);

  Moose::associateSyntax(_syntax, _action_factory);
  ModulesApp::associateSyntax(_syntax, _action_factory);
  GooseApp::associateSyntax(_syntax, _action_factory);
}

GooseApp::~GooseApp()
{
}

// External entry point for dynamic application loading
extern "C" void GooseApp__registerApps() { GooseApp::registerApps(); }
void
GooseApp::registerApps()
{
  registerApp(GooseApp);
}

// External entry point for dynamic object registration
extern "C" void GooseApp__registerObjects(Factory & factory) { GooseApp::registerObjects(factory); }
void
GooseApp::registerObjects(Factory & factory)
{
}

// External entry point for dynamic syntax association
extern "C" void GooseApp__associateSyntax(Syntax & syntax, ActionFactory & action_factory) { GooseApp::associateSyntax(syntax, action_factory); }
void
GooseApp::associateSyntax(Syntax & /*syntax*/, ActionFactory & /*action_factory*/)
{
}
