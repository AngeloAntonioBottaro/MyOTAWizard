unit MyOTAWizard.ProjectMenu.Consts;

interface

uses
  ToolsAPI;

const
  MY_MENU_SEPARATOR = '-';
  MY_MENU_CAPTION  = 'AAB Softwares';
  MY_MENU_POSITION = pmmpRunNoDebug + 200;

  MY_MENU_ITEM_ADICIONAR_PROJETO_CAPTION  = 'Add to projects list';
  MY_MENU_ITEM_ADICIONAR_PROJETO_POSITION = MY_MENU_POSITION + 10;

  MY_MENU_ITEM_GITHUB_DESKTOP_CAPTION  = 'Open github desktop';
  MY_MENU_ITEM_GITHUB_DESKTOP_POSITION = MY_MENU_POSITION + 20;

  MY_MENU_ITEM_GITHUB_WEB_CAPTION  = 'Open github web';
  MY_MENU_ITEM_GITHUB_WEB_POSITION = MY_MENU_POSITION + 25;

  MY_MENU_ITEM_BOSS_INITIALIZE_CAPTION  = 'Boss Init';
  MY_MENU_ITEM_BOSS_INITIALIZED_CAPTION  = 'Boss Initialized';
  MY_MENU_ITEM_BOSS_INITIALIZED_POSITION = MY_MENU_POSITION + 30;

  //BOSS COMMANDS
  BOSS_INIT = 'boss init';
  BOSS_LOGIN = 'boss login';
  BOSS_INSTALL = 'boss install';
  BOSS_UPDATE = 'boss update';
  BOSS_UNINSTALL = 'boss uninstall';

implementation

end.
