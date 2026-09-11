{
  lib,
  config,
  ...
}:
{
  services = lib.mkIf config.systemOptions.enableLocalLlmTools {
    llama-cpp = {
      enable = true;
      port = 8071;
      modelsDir = "/llm-models/";
    };
    llama-swap = {
      enable = true;
      port = 8070;
    };
  };

  preservation.preserveAt."/persisted".directories =
    lib.optionals config.systemOptions.enableLocalLlmTools
      [ config.systemOptions.LocalLlmModelDir ];
}
