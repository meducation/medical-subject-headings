module MESH
  class Translator

    attr_accessor :dictionary

    def translate(input)
      return nil if input.nil?
      input = input.clone
      @downcased.each { |match, replacement| input.gsub!(match, replacement) }
      @capitalized.each { |match, replacement| input.gsub!(match, replacement) }
      @upcased.each { |match, replacement| input.gsub!(match, replacement) }
      input
    end

    def initialize(dictionary)
      @dictionary = dictionary
      @downcased = {}
      @capitalized = {}
      @upcased = {}
      dictionary.each do |match,replacement|
        @downcased[/(^|\W)#{Regexp.quote(match.downcase)}(\W|$)/] = "\\1#{replacement.downcase}\\2"
        @capitalized[/(^|\W)#{Regexp.quote(match.capitalize)}(\W|$)/] = "\\1#{replacement.capitalize}\\2"
        @upcased[/(^|\W)#{Regexp.quote(match.upcase)}(\W|$)/] = "\\1#{replacement.upcase}\\2"
      end
    end

    def self.engb_to_enus
      @@engb_to_enus ||= @@enus_to_engb.invert
    end

    def self.enus_to_engb
      @@enus_to_engb ||= {
        'abrigment' => 'abrigement',
        'acknowledgment' => 'acknowledgement',
        'airplane' => 'aeroplane',
        'aluminum' => 'aluminium',
        'amortize' => 'amortise',
        'analyze' => 'analyse',
        'anemia' => 'anaemia',
        'anesthesia' => 'anaesthesia',
        'anesthetic' => 'anaesthetic',
        'annex' => 'annexe',
        'apprize' => 'apprise',
        'ardor' => 'ardour',
        'bisulfate' => 'bisulphate',
        'caliber' => 'calibre',
        'celiac' => 'coeliac',
        'center' => 'centre',
        'color' => 'colour',
        'curb' => 'kerb',
        'cyanmethemoglobin' => 'cyanmethaemoglobin',
        'defecalgesiophobia' => 'defaecalgesiophobia',
        'defense' => 'defence',
        'dialyze' => 'dialyse',
        'diarrhea' => 'diarrhoea',
        'diarrheagenic' => 'diarrhoeagenic',
        'disulfide' => 'disulphide',
        'dysbetalipoproteinemia' => 'dysbetalipoproteinaemia',
        'ecology' => 'oecology',
        'edema' => 'oedema',
        'electrolyze' => 'electrolyse',
        'endobrachyesophagus' => 'endobrachyoesophagus',
        'enrollment' => 'enrolment',
        'eolian' => 'aeolian',
        'esophagus' => 'oesophagus',
        'esophagitis' => 'oesophagitis',
        'estrogen' => 'oestrogen',
        'etiology' => 'aetiology',
        'favor' => 'favour',
        'favorite' => 'favourite',
        'fervor' => 'fervour',
        'fetus' => 'foetus',
        'fiber' => 'fibre',
        'flavor' => 'flavour',
        'fuscocerulius' => 'fuscocaerulius',
        'genuflection' => 'genuflexion',
        'gonorrhea' => 'gonorrhoea',
        'gynecology' => 'gynaecology',
        'harbor' => 'harbour',
        'hematemesis' => 'haematemesis',
        'hematology' => 'haematology',
        'hemoglobin' => 'haemoglobin',
        'hemorrhoid' => 'haemorrhoid',
        'homeopath' => 'homoeopath',
        'honor' => 'honour',
        'humor' => 'humour',
        'ichthyohemotoxism' => 'ichthyohaemotoxism',
        'inflection' => 'inflexion',
        'jewelry' => 'jewellery',
        'judgment' => 'judgement',
        'kinesiesthesiometer' => 'kinesiaesthesiometer',
        'labor' => 'labour',
        'leukemia' => 'leukaemia',
        'leveling' => 'levelling',
        'license' => 'licence',
        'lodgment' => 'lodgement',
        'luster' => 'lustre',
        'maneuver' => 'manoeuvre',
        'marvelous' => 'marvellous',
        'menorrhea' => 'menorrhoea',
        'meter' => 'metre',
        'microhematocrit' => 'microhaematocrit',
        'mold' => 'mould',
        'molder' => 'moulder',
        'molt' => 'moult',
        'neighbor' => 'neighbour',
        'occipitolevoposterior' => 'occipitolaevoposterior',
        'offense' => 'offence',
        'organize' => 'organise',
        'orthopedics' => 'orthopaedics',
        'paralyze' => 'paralyse',
        'pediatrician' => 'paediatrician',
        'pediatrics' => 'paediatrics',
        'phony' => 'phoney',
        'plow' => 'plough',
        'pretense' => 'pretence',
        'rigor' => 'rigour',
        'savor' => 'savour',
        'sepulcher' => 'sepulchre',
        'specter' => 'spectre',
        'sulfate' => 'sulphate',
        'sulfethylthiadiazole' => 'sulfaethylthiadiazole',
        'synesthesia' => 'synaesthesia',
        'theater' => 'theatre',
        'tire' => 'tyre',
        'tumor' => 'tumour',
        'urohematoporphyrin' => 'urohaematoporphyrin',
        'vapor' => 'vapour',
        'vaporize' => 'vaporise'
      }
    end

  end
end
