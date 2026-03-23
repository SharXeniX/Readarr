import PropTypes from 'prop-types';
import React from 'react';
import FieldSet from 'Components/FieldSet';
import FormGroup from 'Components/Form/FormGroup';
import FormInputGroup from 'Components/Form/FormInputGroup';
import FormLabel from 'Components/Form/FormLabel';
import { inputTypes } from 'Helpers/Props';
import translate from 'Utilities/String/translate';

function MetadataSettings(props) {
  const {
    advancedSettings,
    settings,
    onInputChange
  } = props;

  return (
    <FieldSet legend={translate('MetadataProviderSource')}>
      <FormGroup
        advancedSettings={advancedSettings}
        isAdvanced={true}
      >
        <FormLabel>
          {translate('MetadataSource')}
        </FormLabel>

        <FormInputGroup
          type={inputTypes.TEXT}
          name="metadataSource"
          helpText={translate('MetadataSourceHelpText')}
          helpLink="https://wiki.servarr.com/readarr/settings#metadata"
          onChange={onInputChange}
          {...settings.metadataSource}
        />
      </FormGroup>
    </FieldSet>
  );
}

MetadataSettings.propTypes = {
  advancedSettings: PropTypes.bool.isRequired,
  settings: PropTypes.object.isRequired,
  onInputChange: PropTypes.func.isRequired
};

export default MetadataSettings;
