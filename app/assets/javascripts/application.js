//= require jquery
//= require jquery_ujs
//= require jquery-ui
//= require jquery.remotipart
//= require popper
//= require bootstrap
//= require bootstrap-slider
//= require highcharts
//= require Chart.min
//= require select2
//= require dataTables.min
//= require dataTables.buttons.min
//= require_tree .
//= require_self
//= require intro.min

document.addEventListener("DOMContentLoaded", function() {
    const headers = document.querySelectorAll('.toggle-header')

    headers.forEach(header => {
        const sectionID = header.getAttribute('data-target');
        const section = document.getElementById(sectionID);
        const arrow = header.querySelector('.arrow-indicator');

        section.style.display = 'none';

        header.addEventListener('click', function() {
            if (section.style.display === 'none') {
                section.style.display = 'block';
                arrow.innerHTML = '&#9650;';
            } else {
                section.style.display = 'none';
                arrow.innerHTML = '&#9660;';
            }
        });
    })
    
});