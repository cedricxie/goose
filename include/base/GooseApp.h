#ifndef GOOSEAPP_H
#define GOOSEAPP_H

#include "MooseApp.h"

class GooseApp;

template<>
InputParameters validParams<GooseApp>();

class GooseApp : public MooseApp
{
public:
  GooseApp(InputParameters parameters);
  virtual ~GooseApp();

  static void registerApps();
  static void registerObjects(Factory & factory);
  static void associateSyntax(Syntax & syntax, ActionFactory & action_factory);
};

#endif /* GOOSEAPP_H */
