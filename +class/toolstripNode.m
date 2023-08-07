classdef toolstripNode < class.toolstripComponent

    % A ideia das duas classes - toolstripNode e toolstripComponent é
    % facilitar a criação do arquivo JSON e do parser desse arquivo,
    % criando o toolstrip. Atualmente o parser está confuso! :(

    % Poderia até criar um app no AppDesigner pra gerar esse JSON, 
    % apresentando o AppContainer como saída...

    % O AppContainer teria o método de registro dos componentes criados
    % eventualmente nos painéis e documentos.

    properties
        %-----------------------------------------------------------------%
        positionID   (1,1) double = 1111
        propertyName (1,:) char   = ''
        columnWidth  (1,:) char   = 'auto'
        columnAlign  (1,:) char   = 'auto'
    end
end