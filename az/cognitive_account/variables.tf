variable "name_prefix" {
  type        = string
  description = "Prefix for random generated name"
}

variable "location" {
  type        = string
  description = "Azure region"
}

variable "resource_group_name" {
  type        = string
  description = "Resource group name"
}

variable "random_string_length" {
  type        = number
  description = "Random string length used in resource name"
  default     = 5
}

variable "kind" {
  type        = string
  description = "Type of Cognitive Service Account"
  validation {
    condition     = contains(["Academic", "AnomalyDetector", "Bing.Autosuggest", "Bing.Autosuggest.v7", "Bing.CustomSearch", "Bing.Search", "Bing.Search.v7", "Bing.Speech", "Bing.SpellCheck", "Bing.SpellCheck.v7", "CognitiveServices", "ComputerVision", "ContentModerator", "CustomSpeech", "CustomVision.Prediction", "CustomVision.Training", "Emotion", "Face", "FormRecognizer", "ImmersiveReader", "LUIS", "LUIS.Authoring", "MetricsAdvisor", "OpenAI", "Personalizer", "QnAMaker", "Recommendations", "SpeakerRecognition", "Speech", "SpeechServices", "SpeechTranslation", "TextAnalytics", "TextTranslation", "WebLM"], var.kind)
    error_message = "It should be one of: Academic, AnomalyDetector, Bing.Autosuggest, Bing.Autosuggest.v7, Bing.CustomSearch, Bing.Search, Bing.Search.v7, Bing.Speech, Bing.SpellCheck, Bing.SpellCheck.v7, CognitiveServices, ComputerVision, ContentModerator, CustomSpeech, CustomVision.Prediction, CustomVision.Training, Emotion, Face, FormRecognizer, ImmersiveReader, LUIS, LUIS.Authoring, MetricsAdvisor, OpenAI, Personalizer, QnAMaker, Recommendations, SpeakerRecognition, Speech, SpeechServices, SpeechTranslation, TextAnalytics, TextTranslation or WebLM."
  }
}

variable "sku_name" {
  type        = string
  description = "Pricing plan"
  validation {
    condition     = contains(["F0", "F1", "S0", "S", "S1", "S2", "S3", "S4", "S5", "S6", "P0", "P1", "P2", "E0", "DC0"], var.sku_name)
    error_message = "SKU should be one of: F0, F1, S0, S, S1, S2, S3, S4, S5, S6, P0, P1, P2, E0 or DC0."
  }
}

variable "dynamic_throttling_enabled" {
  type        = string
  description = "Connections throttling"
  default     = false
}

variable "custom_subdomain_name" {
  type        = string
  description = "Subdomain for PEP networks"
  default     = null
}

variable "tags" {
  type        = map(string)
  description = "Resource tags"
}