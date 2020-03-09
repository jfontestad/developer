public with sharing class DataMarketplaceController {
    static Integer PAGE_SIZE = 9;

    public class Filters {
        @AuraEnabled
        public String searchKey { get; set; }
        @AuraEnabled
        public String[] regions { get; set; }
        @AuraEnabled
        public String[] frequencies { get; set; }
        
    }

    public static String getMultiSelectOrFilters(String[] multiSelectValues) {
        List<String> quoted = new List<String>();
        for (String multiSelectValue : multiSelectValues) {
            quoted.add('\'' + multiSelectValue + '\'');
        }
        String quotedString = String.join(quoted, ',');
        System.debug('quotedString = ' + quotedString);
        return quotedString;
    }

    public static String getMultiSelectAndFilters(String[] multiSelectValues) {
        String quotedString = '\'' + String.join(multiSelectValues, ';') + '\'';
        System.debug('quotedString = ' + quotedString);
        return quotedString;
    }

    @AuraEnabled(Cacheable=true)
    public static PagedResult getDatasets(Filters filters, Integer pageNumber) {
        String key, whereClause = '';
        Decimal maxPrice;
        String[] regions, frequencies,criteria = new List<String>{};
        if (filters != null) {
          //  maxPrice = filters.maxPrice;
          //  materials = filters.materials;
          //  levels = filters.levels;
            if (!String.isEmpty(filters.searchKey)) {
                key = '%' + filters.searchKey + '%';
                criteria.add('Name LIKE :key');
            }
            // if (filters.maxPrice >= 0) {
            //     maxPrice = filters.maxPrice;
            //     criteria.add('MSRP__c <= :maxPrice');
            // }

            if (filters.regions != null && !filters.regions.isEmpty()) {
                System.debug('processing regions because they are not null');
                regions = filters.regions;
                List<String> quotedRegions = new List<String>();
                for (String region : regions) {
                    quotedRegions.add('\'' + region + '\'');
                }
                String quotedString = String.join(quotedRegions, ',');
                System.debug('quotedString = ' + quotedString);
                criteria.add('Regions__c includes (' + getMultiSelectAndFilters(regions) + ')');
            }

            if (filters.frequencies != null && !filters.frequencies.isEmpty()) {
                System.debug('processing datatopics because they are not null');
                frequencies = filters.frequencies;
                List<String> quotedFrequencies = new List<String>();
                for (String frequency : frequencies) {
                    quotedFrequencies.add('\'' + frequency + '\'');
                }
                String quotedString = String.join(quotedFrequencies, ',');
                System.debug('quotedString = ' + quotedString);
                criteria.add('Frequency__c includes (' + getMultiSelectAndFilters(frequencies) + ')');
            }

            if (criteria.size() > 0) {
                whereClause = 'WHERE ' + String.join(criteria, ' AND ');
                System.debug('whereClause = ' + whereClause);
            }
           
        }
        
        Integer pageSize = DataMarketplaceController.PAGE_SIZE;
        Integer offset = (pageNumber - 1) * pageSize;
        PagedResult result = new PagedResult();
        result.pageSize = pageSize;
        result.pageNumber = pageNumber;
        result.totalItemCount = Database.countQuery(
            'SELECT count() FROM Data_Set__c ' + whereClause
        );
        result.records = Database.query(
            'SELECT Id, Name, Picture_URL__c, Description__c,' +
            'Frequency__c,Status__c'+
            ' FROM Data_Set__c ' + //, MSRP__c, Description__c, Category__c, Level__c, Material__c
            whereClause +' ORDER BY Name LIMIT :pageSize OFFSET :offset'
        );
        return result;
    }

    @AuraEnabled(Cacheable=true)
    public static Data_Set__c[] getSimilarDatasets(Id datasetId, Id familyId) {
        return [
            SELECT
                Id,
                Name,
                Picture_URL__c,
                Regions__c//,
                // MSRP__c,
                // Description__c,
                // Category__c,
                // Level__c,
                // Picture_URL__c,
                // Material__c
            FROM Data_Set__c
            //WHERE Product_Family__c = :familyId AND Id != :productId
        ];
    }
}