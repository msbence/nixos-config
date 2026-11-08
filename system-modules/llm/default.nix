{
  lib,
  config,
  pkgs,
  ...
}:
{
  services = lib.mkIf config.systemOptions.enableLocalLlmTools {
    llama-cpp = {
      enable = true;
      package = pkgs.llama-cpp-vulkan;
      port = 8071;
      modelsPreset = {
        "Qwen3-Coder-30B-A3B" = {
          model = "${config.systemOptions.LocalLlmModelDir}/Qwen3-Coder-30B-A3B-Instruct-IQ4_XS.gguf";
          alias = "Qwen3-Coder-30B-A3B";
          n-gpu-layers = "99";
          ctx-size = "49152";
          parallel = "1";
          flash-attn = "on";
          cache-type-k = "q8_0";
          cache-type-v = "f16";
          batch-size = "512";
          ubatch-size = "512";
          cache-reuse = "256";
          jinja = "on";

          temp = "0.7";
          top-p = "0.80";
          top-k = "20";
          min-p = "0.0";
          repeat-penalty = "1.05";
        };
      };
    };
    llama-swap = {
      enable = true;
      port = 8070;
    };
  };

  preservation.preserveAt."/persisted".directories =
    lib.optionals config.systemOptions.enableLocalLlmTools
      [
        {
          directory = config.systemOptions.LocalLlmModelDir;
          mode = "0777";
        }
      ];
}
