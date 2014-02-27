module MESH
  class Translator

    def translate(input)
      input = input.clone
      @enus_to_engb.each do |match, replacement|
        start_middle_and_end(input, match.downcase, replacement.downcase)
        start_middle_and_end(input, match.capitalize, replacement.capitalize)
        start_middle_and_end(input, match.upcase, replacement.upcase)
      end
      input
    end

    def initialize
      @enus_to_engb = {
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

    private

    def start_middle_and_end(input, match, replacement)
      input.gsub!(/^#{Regexp.quote(match)}$/, replacement) #alone
      input.gsub!(/^#{Regexp.quote(match)}(\W+)/) { "#{replacement}#{$1}" } #start
      input.gsub!(/(\W+)#{Regexp.quote(match)}(\W+)/) { "#{$1}#{replacement}#{$2}" } #middle
      input.gsub!(/(\W+)#{Regexp.quote(match)}$/) { "#{$1}#{replacement}" } #end
    end

  end
end
